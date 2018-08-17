class Admin::RegistrationsController < Admin::ApplicationController

  before_action :load_training_course

  def index
    @registrations = @training_course.registrations.order("lastname")

    respond_to do |format|
      format.html
      format.xlsx {
        filename = [
          I18n.l(@training_course.date, format: "%Y-%m-%d"),
          @training_course.time.parameterize,
          @training_course.title.parameterize
        ].join("_")

        response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xlsx\""
      }
    end
  end

  def edit
    @registration = @training_course.registrations.find(params[:id])
  end

  def update
    @registration = @training_course.registrations.find(params[:id])

    if @registration.update_attributes(registration_params)
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

private

  def load_training_course
    @training_course = TrainingCourse.find(params[:training_course_id])
  end

  def registration_params
    params.require(:registration).permit(
      :salutation, :firstname, :lastname, :email, :field_of_interest,
      :notes, :internal_notes
    )
  end

end
