module ApplicationHelper

  def active_when(path)
    if path.is_a?(Regexp)
      request.fullpath =~ path ? "active" : "inactive"
    elsif path == true
      "active"
    elsif path == false
      "inactive"
    else
      current_page?(path) ? "active" : "inactive"
    end
  end

end
