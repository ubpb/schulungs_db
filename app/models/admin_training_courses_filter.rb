class AdminTrainingCoursesFilter
  include ActiveModel::Model

  FILTERS = [
    :only_upcoming,
    :from,
    :to,
    :title,
    :published,
    :unpublished,
    :incomplete_statistics,
    :organization_types
  ].freeze

  attr_accessor *FILTERS

  def initialize(filters = {})
    self.filter_attributes = filters
  end

  def filter_attributes=(filters)
    if filters.present? && filters.is_a?(ActionController::Parameters)
      filters = filters.permit(FILTERS)
    end

    filters = ActiveSupport::HashWithIndifferentAccess.new(filters.presence)

    @only_upcoming = to_bool(filters[:only_upcoming].presence)
    @from  = filters[:from].presence&.to_date
    @to  = filters[:to].presence&.to_date
    @title = filters[:title].presence
    @published = to_bool(filters[:published].presence)
    @unpublished = to_bool(filters[:unpublished].presence)
    @incomplete_statistics = to_bool(filters[:incomplete_statistics].presence)
    @organization_types = filters[:organization_types].presence

    if (@published && @unpublished)
      @published = nil
      @unpublished = nil
    end
  end

  def filter_attributes
    FILTERS.inject(ActiveSupport::HashWithIndifferentAccess.new) do |r, f|
      r[f] = self.instance_variable_get("@#{f}")
      r
    end
  end

  def filter(arel)
    arel = filter_upcoming(arel)
    arel = filter_from_to(arel)
    arel = filter_title(arel)
    arel = filter_published(arel)
    arel = filter_unpublished(arel)
    arel = filter_statistics(arel)
    arel = filter_organization_types(arel)
  end

  def active?
    @only_upcoming.present? ||
      @from.present? ||
      @to.present? ||
      @title.present? ||
      @published.present? ||
      @unpublished.present? ||
      @incomplete_statistics.present? ||
      @organization_types.present?
  end

private

  def filter_upcoming(arel)
    if @only_upcoming
      arel.where("date_and_time >= ?", Date.today.beginning_of_day)
    else
      arel
    end
  end

  def filter_from_to(arel)
    if @from.present? || @to.present?
      arel.where(:date_and_time => @from&.beginning_of_day..@to&.end_of_day)
    else
      arel
    end
  end

  def filter_title(arel)
    if @title.present?
      arel.where("training_courses.title like ?", "%#{@title.gsub("%", "")}%")
    else
      arel
    end
  end

  def filter_published(arel)
    if @published
      arel.where( "published")
    else
      arel
    end
  end

  def filter_unpublished(arel)
    if @unpublished
      arel.where.not( "published")
    else
      arel
    end
  end

  def filter_statistics(arel)
    if @incomplete_statistics
      arel.where.not( "statistics_duration > 0 and " +
                      "number_of_participants > 0 and " +
                      "statistics_lecturer <> '' and " +
                      "(statistics_lecturer_md > 0 or statistics_lecturer_gd > 0 or statistics_lecturer_hd > 0) and " +
                      "statistics_presence_types > 0 and " +
                      "statistics_organization_types > 0 and " +
                      "statistics_forms > 0 and " +
                      "statistics_levels > 0 and " +
                      "statistics_categories > 0 and " +
                      "statistics_audiences > 0 and " +
                      "statistics_focus > 0")
    else
      arel
    end
  end

  def filter_organization_types(arel)
    if @organization_types
      arel.where_statistics_organization_types(@organization_types)
    else
      arel
    end
  end

  def to_bool(value)
    value == true || value == 1 || value == '1' || value == "true"
  end
end
