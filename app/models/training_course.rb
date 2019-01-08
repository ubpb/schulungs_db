class TrainingCourse < ApplicationRecord

  # Realations
  has_many :registrations, dependent: :destroy
  has_and_belongs_to_many :categories, -> { order("position") }
  has_and_belongs_to_many :target_audiences, -> { order("position") }

  # Validations
  validates :title, presence: true
  validates :date_and_time, presence: true
  validates :location, presence: true
  validates :max_no_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :number_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :published, -> { where(published: true) }
  scope :upcoming,  -> { where("date_and_time >= ?", Date.today.end_of_day) }
  scope :past,      -> { where("date_and_time < ?", Date.today.end_of_day) }


  def upcoming?
    date_and_time >= Date.today.end_of_day
  end

  def past?
    date_and_time < Date.today.end_of_day
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
