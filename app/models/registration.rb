class Registration < ApplicationRecord

  # Relations
  belongs_to :training_course
  has_and_belongs_to_many :institutions, -> { order("position") }
  has_many :certificate_digests, dependent: :destroy

  # Validations
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :dsgvo_consent, acceptance: { accept: true }
  validate :has_at_least_one_institution

  def fullname
    [firstname, lastname].map(&:presence).compact.join(" ")
  end

  private

  def has_at_least_one_institution
    if Institution.exists? &&
        training_course.present? &&
        training_course.enable_institutions_for_registrations &&
        institutions.blank?
      errors.add(:institutions, :has_no_institution)
    end
  end

end
