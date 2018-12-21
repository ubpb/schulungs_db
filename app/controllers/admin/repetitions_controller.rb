class Admin::RepetitionsController < Admin::ApplicationController

  before_action :load_training_course

  def new
    start_date = @training_course.date_and_time.to_date
    end_date   = @training_course.date_and_time.to_date
    @repetition = Repetition.new(start_date: start_date, end_date: end_date)
  end

  def create
    @repetition = Repetition.new(repetition_params)

    if @repetition.create_repetitions_from(@training_course)
      flash[:success] = t(".flash.success")
      redirect_to admin_training_courses_path
    else
      render :new
    end
  end

private

  def load_training_course
    @training_course = TrainingCourse.find(params[:training_course_id])
  end

  def repetition_params
    params.require(:repetition).permit(:interval, :start_date, :end_date)
  end

end
