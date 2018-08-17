class Admin::ApplicationController < ApplicationController

  layout "admin/application"

  before_action :authenticate!

private

  def authenticate!
    authenticate_or_request_with_http_basic do |username, password|
      # Create the hash with BCrypt::Password.create("mypassword")
      secure_password = BCrypt::Password.new("$2a$10$tIn1TbsFf7N91sKIMyM/qegksPWejFInWBHwdtJ1xQvMOAT.PiFvy")
      username == "admin" && secure_password == password
    end
  end

end
