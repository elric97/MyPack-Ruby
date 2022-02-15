class User < ApplicationRecord
  has_secure_password
  has_one :student
  has_one :instructor
  has_one :admin
  validates :name, presence: true
  validates :email, uniqueness: true, presence: true,  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_digest, presence: true

end
