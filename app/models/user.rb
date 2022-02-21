class User < ApplicationRecord
  has_secure_password
  has_one :student, dependent: :destroy
  has_one :instructor, dependent: :destroy
  has_one :admin, dependent: :destroy
  validates :email, uniqueness: true, presence: true,  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_digest, presence: true
  validates :name, presence: true
  validate :check_if_empty_name, :check_if_empty_email, :check_if_empty_password_digest


  def check_if_empty_name
    errors.add(:name, 'cannot be an empty string') if name.nil? || name == " "
  end

  def check_if_empty_email
    errors.add(:email, 'cannot be an empty string') if email.nil? || email == " "
  end

  def check_if_empty_password_digest
    errors.add(:password_digest, 'cannot be an empty string') if password_digest.nil? || password_digest == " "
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
