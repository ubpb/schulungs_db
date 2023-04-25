class Admin::TrainingCoursesController < Admin::ApplicationController

  def index
    respond_to do |format|


      format.html {
        @upcoming_training_courses = TrainingCourse.upcoming.includes(:registrations).order("date_and_time asc")
        @past_training_courses = TrainingCourse.past.includes(:registrations).order("date_and_time desc")
      }

      format.xlsx {
        if params[:data].present?
          @from = params[:data][:from]&.to_date
          @to = params[:data][:to]&.to_date
          # Query course between these dates
          @training_courses = TrainingCourse.where(:date_and_time => @from..@to).each

          filename = [
            @from&.strftime("%F"),
            @to&.strftime("%F"),
            "statistics"
          ].compact.join("_")

          response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xlsx\""
        end
      }
    end
  end

  def new
    @training_course = TrainingCourse.new
    @training_course.date_and_time = 3.days.from_now.change({ hour: 10, min: 0, sec: 0 })
  end

  def create
    @training_course = TrainingCourse.new(training_course_params)

    if @training_course.save
      flash[:success] = t(".flash.success")
      redirect_to(admin_training_courses_path)
    else
      render(:new)
    end
  end

  def edit
    @training_course = TrainingCourse.find(params[:id])
  end

  def update
    @training_course = TrainingCourse.includes(:registrations).find(params[:id])
    @training_course.assign_attributes(training_course_params)

    if @training_course.valid?
      if @training_course.upcoming?
        if @training_course.date_and_time_changed? || @training_course.location_changed?
          @training_course.registrations.each do |registration|
            Mailers::TrainingCoursesMailer.data_changed_notification(@training_course, registration).deliver
          end
        end
      end

      @training_course.save

      flash[:success] = t(".flash.success")

      if params[:submit_and_edit].present?
        redirect_to edit_admin_training_course_path(@training_course)
      else
        redirect_to admin_training_courses_path
      end
    else
      render(:edit)
    end
  end

  def destroy
    @training_course = TrainingCourse.find(params[:id])

    if @training_course.destroy
      flash[:success] = t(".flash.success")
    else
      flash[:error] = t(".flash.error")
    end

    redirect_to(admin_training_courses_path)
  end

  def batch_update
    training_courses = TrainingCourse.where(id: params[:training_course_ids])
    action = params[:multi_edit_action]

    if training_courses.present? && action
      case action
      when "publish" then batch_update_toggle_publish(training_courses, published: true)
      when "unpublish" then batch_update_toggle_publish(training_courses, published: false)
      end

      flash[:success] = t(".flash.success")
    end

    redirect_to(admin_training_courses_path)
  end

  def export_csv
    from = Date.strptime params[:data][:from]
    to = params[:data][:to]

    csv = [ "2018;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;",
            "ID;Bibliothek;OPTIONAL: Dozent/in oder Bibliothek;Veranstaltungsdauer;Organisatorische Form;;;;;;;;Didaktische Form;;Niveau;;;Integration;Fachliche Ausrichtung;Dozent;;;;;Zielgruppe;;;;;;;;;;;;;Schwerpunkte;;;;;;;;;;;;Teilnehmerzahl;Sitzungsanzahl;Semester;Datum;Text 1;Text 2;Text 3;Text 4;Text 5;",
            "ID;Bibliothek;OPTIONAL: Dozent/in oder Bibliothek;Veranstaltungsdauer;Eigenstaendige Bibliotheksveranstaltung (nicht semesterlang);Integrierte Einheit in universitaerer Lehrveranst.;Eigenstaendiger Kurs ueber ein Semester;Beratung;E-Tutorials, Filme, Audioguides (bei Teilnehmerzahl Klickzahlen eintragen);Webinare;Lernplattformen/E-Learning-Kurse;Blended-Learning;Praesentation, Fuehrung, Vortrag;Praktische Uebung, Workshop;keine Angaben;Einfuehrung;Vertiefung;Integration;Fachliche Ausrichtung;Bibliothekar/in gehobener Dienst;Bibliothekar/in hoeherer Dienst;Bibliothekar/in mittlerer Dienst;Studentische Hilfskraft;Sonstige;Grundstudium/Bachelorstudium;Hauptstudium/Masterstudium;Tutor/inn/en/Hilfskraefte;Doktorand/inn/en;Lehrende/Wissenschaftler/innen;Sonstige Universitaetsmitarbeiter;Schueler/innen;Auszubildende;Lehrer/innen;Senior/inn/en;auslaendische Studierende;Externe/Sonstige;unspezifische Gruppe;Informationskompetenz umfassend (Kurse mit umfassenden Ansatz);Bibliotheksbenutzung (z. B. raeumliche Orientierung, Ansprechpartner, Homepage, Kataloge (ohne Vertiefung in Suchstrategien und -techniken));Suchstrategien und Suchtechniken (ueberwiegend methodischer Ansatz);Einzelne Kataloge und Datenbanken (Handhabung einzelner Kataloge und Datenbanken);Internetrecherche (z. B. Suchmaschinen, Internetverzeichnisse, Fachportale / Evaluierung von Internetressourcen);Informationsverarbeitung/-verwaltung (z. B. Literaturverwaltungsprogramme, Praesentationsprogramme, Lernplattform);Rechtliche, oekonom. und ethische Fragen (z. B. Open Access, Urheberrecht);Elektronisches Publizieren (z. B. Hochschulserver, technische Handhabung, organisatorische Fragen);Fernleihe/Dokumentlieferung;Sonstige;Wissenschaftliches Arbeiten und Publizieren;Umgang mit Sondermaterialien/Sammlungen ;Teilnehmerzahl;Sitzungsanzahl;Semester;Datum;Text 1;Text 2;Text 3;Text 4;Text 5;" ]

    TrainingCourse.all.each do |tc|
      line = Array.new(59)

      line[1] = "Paderborn"
      line[2] = "Dozent"
      line[3] = tc.duration

      # Organisatorische Form
      line[4] = tc.statistics_organization_types.library? ? 1 : 0
      line[5] = tc.statistics_organization_types.integrated? ? 1 : 0
      line[6] = tc.statistics_organization_types.independent? ? 1 : 0
      line[7] = tc.statistics_organization_types.consultation? ? 1 : 0
      line[8] = tc.statistics_organization_types.media? ? 1 : 0
      line[9] = tc.statistics_organization_types.webinar? ? 1 : 0
      line[10] = tc.statistics_organization_types.elearning? ? 1 : 0
      line[11] = tc.statistics_organization_types.blended? ? 1 : 0

      # Didaktische Form
      line[12] = tc.statistics_forms.presentation? ? 1 : 0
      line[13] = tc.statistics_forms.workshop? ? 1 : 0

      # Niveau
      # 14 fehlt
      line[15] = tc.statistics_levels.beginner? ? 1 : 0
      line[16] = tc.statistics_levels.advanced? ? 1 : 0

      # Integration
      line[17] = tc.statistics_organization_types.integrated? ? 3 : 1

      # Fachliche Ausrichtung
      #line[18]

      # Dozent
      #line[19-23]

      # Zielgruppe
      line[24] = tc.statistics_audiences.bachelor_students? ? 1 : 0
      line[25] = tc.statistics_audiences.master_students? ? 1 : 0
      line[26] = tc.statistics_audiences.tutors? ? 1 : 0
      line[27] = tc.statistics_audiences.phd_students? ? 1 : 0
      line[28] = tc.statistics_audiences.scientists? ? 1 : 0
      line[29] = tc.statistics_audiences.university_others? ? 1 : 0
      line[30] = tc.statistics_audiences.pupils? ? 1 : 0
      line[31] = tc.statistics_audiences.trainees? ? 1 : 0
      line[32] = tc.statistics_audiences.teachers? ? 1 : 0
      line[33] = tc.statistics_audiences.seniors? ? 1 : 0
      line[34] = tc.statistics_audiences.forign_students? ? 1 : 0
      line[35] = tc.statistics_audiences.others? ? 1 : 0
      # 36 unspezifische Gruppe

      # Schwerpunkte
      line[37] = tc.statistics_focus.information_competence? ? 1 : 0
      line[38] = tc.statistics_focus.library_usage? ? 1 : 0
      line[39] = tc.statistics_focus.search_methods? ? 1 : 0
      line[40] = tc.statistics_focus.catalogs? ? 1 : 0
      line[41] = tc.statistics_focus.internet_research? ? 1 : 0
      line[42] = tc.statistics_focus.information_managment? ? 1 : 0
      line[43] = tc.statistics_focus.legal_issues? ? 1 : 0
      line[44] = tc.statistics_focus.electronic_publishing? ? 1 : 0
      line[45] = tc.statistics_focus.interlending? ? 1 : 0
      line[46] = tc.statistics_focus.others? ? 1 : 0
      line[47] = tc.statistics_focus.scientific_work? ? 1 : 0
      line[48] = tc.statistics_focus.special_collections? ? 1 : 0

      # Teilnehmerzahl
      line[49] = tc.number_of_participants

      # Sitzungsanzahl
      # Semester

      # Datum
      line[52] = tc.date_and_time.strftime("%F")

      # Text 1
      line[53] = tc.title
      # Text 2
      # Text 3
      # Text 4
      # Text 5
      line[57] = tc.location

      line[-1] = "//"

      csv.push(line.join(";"))
    end

    send_data csv.join("\r\n")
  end

  def preview_reminder_message
    training_course = TrainingCourse.find(params[:id])
    dummy_registration = Registration.new(
      salutation: "frau",
      firstname: "Claudia",
      lastname: "Kroner",
      email: "schulungen@ub.uni-paderborn.de"
    )

    mail = Mailers::TrainingCoursesMailer.reminder_message(training_course, dummy_registration)

    render plain: mail.body.to_s, layout: false
  end

private

  def training_course_params
    params.require(:training_course).permit(
      :title,
      :location,
      :date_and_time,
      :published,
      :description,
      :registration_required,
      :max_no_of_participants,
      :duration,
      :learning_targets,
      :number_of_participants,
      :email,
      :reminder_message,
      :enable_institutions_for_registrations,
      :enable_field_of_interest_for_registrations,
      :statistics_lecturer,
      :statistics_organization_types,
      :statistics_levels,
      :statistics_categories,
      statistics_forms: [],
      statistics_audiences: [],
      statistics_focus: [],
      category_ids: [],
      target_audience_ids: []
    )
  end

  def batch_update_toggle_publish(training_courses, published:)
    training_courses.update_all(published: published)
  end

end
