class User < ApplicationRecord
  has_secure_password
  has_one :student
  has_one :instructor
  has_one :admin
  validates :email, uniqueness: true, presence: true
end
