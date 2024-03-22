class CertificateDigest < ApplicationRecord
  belongs_to :registration

  validates :digest, presence: true, uniqueness: true
  validates :initials, presence: true
end
