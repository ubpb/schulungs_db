class TrainingCourse < ApplicationRecord

  # Realations
  has_many :registrations, dependent: :destroy
  has_and_belongs_to_many :categories, -> { order("title") }
  has_and_belongs_to_many :target_audiences, -> { order("title") }

  # Validations
  validates :title, presence: true
  validates :date, presence: true
  validates :time, presence: true, format: { with: /\A\d\d:\d\d\z/ }
  validates :location, presence: true
  validates :max_no_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 1 }

  # Scopes
  scope :published, -> { where(published: true) }
  scope :upcoming,  -> { where("date >= ?", Time.zone.now) }
  scope :past,      -> { where("date < ?", Time.zone.now) }


  def upcoming?
    date >= Time.zone.now
  end

  def past?
    date < Time.zone.now
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
    "#{id},#{title.parameterize},#{I18n.l(date).parameterize},#{time.parameterize}"
  end

end
