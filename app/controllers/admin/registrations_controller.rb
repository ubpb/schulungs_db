class Admin::RegistrationsController < Admin::ApplicationController

  before_action :load_training_course

  def index
    @registrations = @training_course.registrations.order("lastname")

    respond_to do |format|
      format.html
      format.xlsx {
        filename = [
          I18n.l(@training_course.date_and_time.to_date, format: "%Y-%m-%d").parameterize,
          I18n.l(@training_course.date_and_time.to_time, format: "%H-%M").parameterize,
          @training_course.title.parameterize
        ].join("_")

        response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}.xlsx\""
      }
    end
  end

  def new
    @registration = @training_course.registrations.new
  end

  def edit
    @registration = @training_course.registrations.find(params[:id])
  end

  def create
    @registration = @training_course.registrations.new(registration_params)
    @registration.dsgvo_consent = true

    if @registration.save
      flash[:success] = t("admin.registrations.update.flash.success")
      redirect_to admin_training_course_registrations_path(@training_course)
    else
      render :new
    end
  end

  def update
    @registration = @training_course.registrations.find(params[:id])

    if @registration.update(registration_params)
      flash[:success] = t(".flash.success")
      redirect_to admin_training_course_registrations_path(@training_course)
    else
      render :edit
    end
  end

  def destroy
    @registration = @training_course.registrations.find(params[:id])

    if @registration.destroy
      flash[:success] = t(".flash.success")
    else
      flash[:error] = t(".flash.error")
    end

    redirect_to admin_training_course_registrations_path(@training_course)
  end

  def download_certificate
    @registration = @training_course.registrations.find(params[:id])

    cert = generate_cert_pdf(@registration)

    send_data(
      cert,
      filename: cert_filename(@registration),
      type: "application/pdf",
      disposition: "attachment"
    )
  end

  def email_certificate
    @registration = @training_course.registrations.find(params[:id])
    send_cert_email(@registration)

    flash[:success] = "Teilnahmebescheinigung wurde versendet"
    redirect_to admin_training_course_registrations_path(@training_course)
  end

  def batch_update
    registrations = Registration.includes(:training_course).where(id: params[:registration_ids])
    action = params[:multi_edit_action]

    if registrations.present? && action
      case action
      when "send_cert_email" then batch_send_cert_email(registrations)
      end
    end

    redirect_to admin_training_course_registrations_path(@training_course)
  end

  def batch_send_cert_email(registrations)
    registrations.each do |registration|
      send_cert_email(registration)
    end

    flash[:success] = "Teilnahmebescheinigungen wurden versendet"
  end

  private

  def load_training_course
    @training_course = TrainingCourse.find(params[:training_course_id])
  end

  def registration_params
    params.require(:registration).permit(
      :firstname, :lastname, :email, :field_of_interest,
      :notes, :internal_notes, institution_ids: []
    )
  end

  def send_cert_email(registration)
    cert = generate_cert_pdf(registration)

    Mailers::RegistrationsMailer.certificate(
      registration,
      cert,
      cert_filename(registration),
    ).deliver_later

    registration.update(certificate_sent_at: Time.zone.now)
  end

  def generate_cert_pdf(registration)
    upb_logo = Rails.root.join("etc/cert-upb-logo.png").to_s
    ub_logo = Rails.root.join("etc/cert-ub-logo.png").to_s
    io = StringIO.new("".b)

    # Create the PDF
    HexaPDF::Composer.create(io, page_size: :A4, margin: [40, 40, 40, 60]) do |pdf|
      pdf.style(:base, font: "Helvetica", font_size: 12, line_spacing: 2)
      # pdf.document.config['debug'] = true

      pdf.image(upb_logo, width: 150, position: :float, margin: [0, 0], style: {align: :left})
      pdf.image(ub_logo, width: 130, position: :default, margin: [0, 0], style: {align: :right})

      pdf.text("Teilnahmebescheinigung", font_size: 20, align: :left, margin: [60, 0, 0, 0], font: ["Helvetica", variant: :bold])

      pdf.text(registration.fullname, font: ["Helvetica", variant: :bold], margin: [40, 0, 0, 0])
      pdf.text("hat im Rahmen der Angebote zur Informationskompetenz der Universitätsbibliothek am #{I18n.l(registration.training_course.date_and_time.to_date)} an der Veranstaltung", margin: [20, 0, 0, 0])
      pdf.text(registration.training_course.title, font: ["Helvetica", variant: :bold], margin: [20, 0, 0, 0])
      pdf.text("teilgenommen.", margin: [20, 0, 0, 0])

      if registration.training_course.certificate_learning_results.present?
        pdf.text("Inhalte der Veranstaltung waren:", margin: [20, 0, 20, 0])
        pdf.box(:list, item_spacing: 10) do |list|
          registration.training_course.certificate_learning_results.each_line do |line|
            list.text(line.strip)
          end
        end
      end

      pdf.text("Paderborn, #{I18n.l(Time.zone.now.to_date)}", margin: [40, 0, 0, 0])

      if registration.training_course.certificate_signature.present?
        pdf.text(registration.training_course.certificate_signature, margin: [20, 0, 0, 0])
      end

      pdf.formatted_text(
        [{
          text: "Hinweis: Die Gültigkeit der digitalen Version dieser Teilnahmebescheinigung kann unter https://schulungen.ub.uni-paderborn.de/validate überprüft werden",
          fill_color: "gray"
        }],
        valign: :bottom,
        margin: [20, 0, 0, 0],
        align: :center,
        font_size: 8
      )
    end

    # Secure the PDF, allowing only printing
    doc = HexaPDF::Document.new(io: io)
    out_io = StringIO.new("".b)
    doc.encrypt(
      owner_password: SecureRandom.hex(10),
      permissions: HexaPDF::Encryption::StandardSecurityHandler::Permissions::PRINT
    )
    doc.write(out_io)

    # Get the PDF content
    cert = out_io.string

    # Store digest for later verification
    registration.certificate_digests.create!(
      digest: Digest::SHA256.hexdigest(cert),
      initials: [
        registration.firstname&.slice(0..1),
        registration.lastname&.slice(0..1)
      ].compact.join(" / ")
    )

    cert
  end

  def cert_filename(registration)
    [
      registration.training_course.date_and_time.to_date.strftime("%Y%m%d"),
      "teilnahmebescheinigung",
      registration.lastname.downcase.parameterize
    ].join("_") + ".pdf"
  end
end
