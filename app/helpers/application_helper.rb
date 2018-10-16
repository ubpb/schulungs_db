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

  def date_in_words(date)
    case date
    when Date.today          then t("datetime.today")
    when Date.today + 1.day  then t("datetime.tomorrow")
    when Date.today + 2.days then t("datetime.day_after_tomorrow")
    else distance_of_time_in_words_to_now(date, scope: "datetime.distance_in_words.date_only")
    end
  end

end
