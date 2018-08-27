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

  def set_page_title(title)
    @page_title = title
  end

  def page_title
    @page_title
  end
  helper_method :page_title

end
