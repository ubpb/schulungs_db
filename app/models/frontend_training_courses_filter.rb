class FrontendTrainingCoursesFilter
  include ActiveModel::Model

  DATE_FILTER = [:week, :month, :quarter].freeze

  attr_accessor :date
  attr_accessor :title
  attr_accessor :target_audiences
  attr_accessor :categories

  def filter(arel)
    self.date  = self.date.presence
    self.title = self.title.presence
    self.target_audiences = (self.target_audiences.presence || []).map(&:presence).compact.map(&:to_i)
    self.categories = (self.categories.presence || []).map(&:presence).compact.map(&:to_i)

    arel = filter_date(arel)
    arel = filter_title(arel)
    arel = filter_target_audiences(arel)
    arel = filter_categories(arel)
    arel
  end

  def active?
    self.date.present? || self.title.present? || self.target_audiences.present? || self.categories.present?
  end

private

  def filter_date(arel)
    case self.date
    when "week"    then arel.where("date_and_time <= ?", 1.week.from_now)
    when "month"   then arel.where("date_and_time <= ?", 1.month.from_now)
    when "quarter" then arel.where("date_and_time <= ?", 3.month.from_now)
    else arel
    end
  end

  def filter_title(arel)
    if self.title.present?
      arel.where("training_courses.title like ?", "%#{self.title.gsub("%", "")}%")
    else
      arel
    end
  end

  def filter_target_audiences(arel)
    if self.target_audiences.present?
      arel.left_joins(:target_audiences).where("target_audiences.id IN (?)", self.target_audiences)
    else
      arel
    end
  end

  def filter_categories(arel)
    if self.categories.present?
      arel.left_joins(:categories).where("categories.id IN (?)", self.categories)
    else
      arel
    end
  end

end
