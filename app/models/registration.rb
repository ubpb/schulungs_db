class Registration < ApplicationRecord

  SALUTATIONS = [:herr, :frau].freeze

  # Relations
  belongs_to :training_course

  # Validations
  validates :salutation, presence: true, inclusion: { in: SALUTATIONS.map(&:to_s) }
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def fullname
    [firstname, lastname].map(&:presence).compact.join(" ")
  end

end
