class TrainingCourse < ApplicationRecord

  # Realations
  has_many :registrations, dependent: :destroy
  has_and_belongs_to_many :categories, -> { order("position") }
  has_and_belongs_to_many :target_audiences, -> { order("position") }

  # Validations
  validates :title, presence: true
  validates :date_and_time, presence: true
  validates :location, presence: false
  validates :max_no_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :number_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :statistics_duration, numericality: { greater_than_or_equal_to: 0 }
  validates :statistics_lecturer_md, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :statistics_lecturer_gd, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :statistics_lecturer_hd, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :email_from, format: { with: /\A^$|([^@\s]+)@ub.uni-paderborn.de\z/i }

  # Scopes
  scope :published, -> { where(published: true) }
  scope :upcoming,  -> { where("date_and_time >= ?", Date.today.beginning_of_day) }
  scope :past,      -> { where("date_and_time < ?", Date.today.beginning_of_day) }

  # Flags
  flag :statistics_presence_types,      [ :presence,
                                          :online ]
  flag :statistics_organization_types,  [ :library,
                                          :integrated,
                                          :independent,
                                          :consultation,
                                          :media,
                                          :webinar,
                                          :elearning,
                                          :blended ]
  flag :statistics_forms,               [ :presentation,
                                          :workshop ]
  flag :statistics_levels,              [ :beginner,
                                          :advanced ]
  flag :statistics_categories,          [ :interdisciplinary,
                                          :english_studies,
                                          :german_studies,
                                          :romance_studies,
                                          :history,
                                          :art_history,
                                          :musicology,
                                          :philosophy,
                                          :theology,
                                          :nutritional_science,
                                          :computer_science,
                                          :engineering,
                                          :chemistry,
                                          :geography,
                                          :physics,
                                          :natural_science,
                                          :media_studies,
                                          :pedagogy,
                                          :sociology,
                                          :psychology,
                                          :economics,
                                          :sports,
                                          :other ]
  flag :statistics_audiences,           [ :bachelor_students,
                                          :master_students,
                                          :tutors,
                                          :phd_students,
                                          :scientists,
                                          :university_others,
                                          :pupils,
                                          :trainees,
                                          :teachers,
                                          :seniors,
                                          :forign_students,
                                          :others ]
  flag :statistics_focus,               [ :information_competence,
                                          :library_usage,
                                          :search_methods,
                                          :catalogs,
                                          :internet_research,
                                          :information_managment,
                                          :legal_issues,
                                          :electronic_publishing,
                                          :interlending,
                                          :scientific_work,
                                          :special_collections,
                                          :others ]



  # Upcoming includes "today".
  def upcoming?
    date_and_time >= Date.today.beginning_of_day
  end

  def past?
    date_and_time < Date.today.beginning_of_day
  end

  def limited?
    max_no_of_participants > 0
  end

  def no_of_free_spaces
    if limited?
      spaces_count = max_no_of_participants - registrations.count
      spaces_count < 0 ? 0 : spaces_count
    else
      0
    end
  end

  def full?
    limited? && registrations.count >= max_no_of_participants
  end

  def to_param
    if title.present? && date_and_time.present?
      "#{id},#{title.parameterize},#{I18n.l(date_and_time.to_date).parameterize},#{I18n.l(date_and_time.to_time, format: "%H:%M").parameterize}"
    else
      "#{id}"
    end
  end

end
