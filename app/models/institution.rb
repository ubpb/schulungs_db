class Institution < ApplicationRecord

  # Relations
  has_and_belongs_to_many :registrations

  # Validations
  validates :title, presence: true, uniqueness: true

  # List support
  acts_as_list

end
