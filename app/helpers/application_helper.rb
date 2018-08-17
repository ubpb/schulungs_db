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

  def render_markdown(s)
    GitHub::Markup.render_s(GitHub::Markups::MARKUP_MARKDOWN, s)
  end

end
