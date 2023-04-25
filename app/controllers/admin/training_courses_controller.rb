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
