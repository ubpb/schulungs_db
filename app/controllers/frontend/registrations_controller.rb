class Frontend::RegistrationsController < Frontend::ApplicationController

  def new
    @training_course = TrainingCourse.published.upcoming.find(params[:training_course_id])
    @registration = @training_course.registrations.build

    verify_training_course or return
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(".flash.error")
    redirect_to frontend_training_courses_path
  end

  def create
    @training_course = TrainingCourse.published.upcoming.find(params[:training_course_id])
    @registration = @training_course.registrations.build(registration_params)

    verify_training_course or return

    if @registration.save
      flash[:success] = "Anmeldung erfolgreich gespeichert."
      Mailers::RegistrationsMailer.registration_confirmation(@registration).deliver
      Mailers::RegistrationsMailer.registration_notification(@registration).deliver
      redirect_to frontend_training_courses_path
    else
      render :new
    end
  end

private

  def verify_training_course
    unless @training_course.registration_required?
      flash[:error] = t(".flash.no_registration_error")
      redirect_to frontend_training_course_path(@training_course) and return
    end

    if @training_course.full?
      flash[:error] = t(".flash.full_error")
      redirect_to frontend_training_course_path(@training_course) and return
    end

    return true
  end

  def registration_params
    params.require(:registration).permit(:salutation, :firstname, :lastname, :email, :field_of_interest, :notes)
  end

end
