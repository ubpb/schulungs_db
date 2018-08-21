class Frontend::ApplicationController < ApplicationController

  layout "frontend/application"

private

  def add_breadcrumb(label, url)
    (@breadcrumbs ||= []) << {label: label, url: url}
  end

  def breadcrumbs
    @breadcrumbs || []
  end
  helper_method :breadcrumbs

end
