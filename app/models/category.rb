class Category < ApplicationRecord

  # Relations
  has_and_belongs_to_many :training_courses

  # Validations
  validates :title, presence: true, uniqueness: true

  # List support
  acts_as_list

end
