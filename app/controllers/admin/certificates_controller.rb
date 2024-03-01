class Admin::CertificatesController < Admin::ApplicationController

  def index

    @training_course = TrainingCourse.find(params[:training_course_id])
    @registration = @training_course.registrations.find(params[:registration_id])

    respond_to do |format|
      format.pdf do
        render template: "admin/certificates/index.pdf.slim",
               pdf: "#{@training_course.date_and_time.to_date.strftime("%Y%m%d")}_teilnahmebescheinigung_#{@registration.lastname.downcase.parameterize}",
               layout: 'pdf.html'
      end
    end
  end

end
