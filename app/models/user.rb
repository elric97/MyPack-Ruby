class User < ApplicationRecord
  has_secure_password
  has_one :student, dependent: :destroy
  has_one :instructor, dependent: :destroy
  has_one :admin, dependent: :destroy
  validates :email, uniqueness: true, presence: true
end
