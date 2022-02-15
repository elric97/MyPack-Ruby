class User < ApplicationRecord
  has_secure_password
  has_one :student, dependent: :destroy
  has_one :instructor, dependent: :destroy
  has_one :admin, dependent: :destroy
  validates :email, uniqueness: true, presence: true,  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_digest, presence: true

  def can_assign_roles?
    role == 'Admin'
  end
end
