class User < ApplicationRecord
  has_secure_password
  has_one :student, dependent: :destroy
  has_one :instructor, dependent: :destroy
  has_one :admin, dependent: :destroy
  validates :email, uniqueness: true, presence: true,  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_digest, presence: true
  validates :name, presence: true
  validate :check_if_empty_name


  def check_if_empty_name
    errors.add(:name, 'cannot be an empty string') if nil? || name == " "
  end
  def can_assign_roles?
    role == 'Admin'
  end

  def can_crud?(user)
    role == 'Admin' || id == user.id
  end

  def can_destroy?(user)
    role == 'Admin' && user.role != 'Admin'
  end
end
