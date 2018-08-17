class Frontend::TrainingCoursesController < Frontend::ApplicationController

  def index
    @filter = FrontendTrainingCoursesFilter.new(params[:filter].present? ? filter_params : {})

    @training_courses = TrainingCourse.includes(:categories, :target_audiences).upcoming.published.order("date asc")
    @training_courses = @filter.filter(@training_courses)
  end

  def show
    @training_course = TrainingCourse.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(".flash.error")
    redirect_to frontend_training_courses_path
  end

private

  def filter_params
    params.require(:filter).permit!
  end

end
