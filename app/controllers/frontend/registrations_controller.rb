class Frontend::RegistrationsController < Frontend::ApplicationController

  def new
    @training_course = TrainingCourse.published.upcoming.find(params[:training_course_id])
    @registration = @training_course.registrations.build

    set_breadcrumbs_and_page_title

    verify_training_course or return
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t("frontend.registrations.flash.error")
    redirect_to frontend_training_courses_path
  end

  def create
    @training_course = TrainingCourse.published.upcoming.find(params[:training_course_id])
    @registration = @training_course.registrations.build(registration_params)

    set_breadcrumbs_and_page_title

    verify_training_course or return

    if @registration.save
      flash[:success] = t("frontend.registrations.flash.success", email: @registration.email)
      Mailers::RegistrationsMailer.registration_confirmation(@registration).deliver
      Mailers::RegistrationsMailer.registration_notification(@registration).deliver

      if @training_course.date_and_time.to_date == Date.today && @registration.sent_reminder_message_at.blank?
        Mailers::TrainingCoursesMailer.reminder_message(@training_course, @registration).deliver
        @registration.update_column(:sent_reminder_message_at, Time.zone.now)
      end

      redirect_to frontend_training_courses_path
    else
      render :new
    end
  end

private

  def set_breadcrumbs_and_page_title
    add_breadcrumb(t("frontend.breadcrumbs.training_courses.index"), frontend_training_courses_path)
    add_breadcrumb(t("frontend.breadcrumbs.training_courses.show", title: @training_course.title), frontend_training_course_path(@training_course))
    add_breadcrumb(t("frontend.breadcrumbs.registrations.new"), new_frontend_training_course_registration_path(@training_course))

    set_page_title(t("frontend.page_titles.registrations.new"))
  end

  def verify_training_course
    unless @training_course.registration_required?
      flash[:error] = t("frontend.registrations.flash.no_registration_error")
      redirect_to frontend_training_course_path(@training_course) and return
    end

    if @training_course.date_and_time.today?
      flash[:error] = t("frontend.registrations.flash.registration_closed_error")
      redirect_to frontend_training_course_path(@training_course) and return
    end

    if @training_course.full?
      flash[:error] = t("frontend.registrations.flash.full_error")
      redirect_to frontend_training_course_path(@training_course) and return
    end

    return true
  end

  def registration_params
    params.require(:registration).permit(
      :salutation, :firstname, :lastname, :email, :field_of_interest,
      :notes, :dsgvo_consent, institution_ids: []
    )
  end

end
