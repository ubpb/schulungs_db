class Frontend::TrainingCoursesController < Frontend::ApplicationController

  def index
    @filter = FrontendTrainingCoursesFilter.new(params[:filter].present? ? filter_params : {})

    @training_courses = TrainingCourse.includes(:categories, :target_audiences).upcoming.published.order("date_and_time asc")
    @training_courses = @filter.filter(@training_courses)

    add_breadcrumb(t("frontend.breadcrumbs.training_courses.index"), frontend_training_courses_path)

    set_page_title(t("frontend.page_titles.training_courses.index"))
  end

  def show
    @training_course = TrainingCourse.published.find(params[:id])

    add_breadcrumb(t("frontend.breadcrumbs.training_courses.index"), frontend_training_courses_path)
    add_breadcrumb(t("frontend.breadcrumbs.training_courses.show", title: @training_course.title), frontend_training_course_path(@training_course))

    set_page_title(t("frontend.page_titles.training_courses.show",
      title: @training_course.title,
      date: I18n::l(@training_course.date_and_time.to_date),
      time: I18n::l(@training_course.date_and_time.to_time, format: :short))
    )
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(".flash.error")
    redirect_to frontend_training_courses_path
  end

private

  def filter_params
    params.require(:filter).permit!
  end

end
