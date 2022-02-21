class Instructor < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  delegate :name, :email, to: :user, allow_nil: :true
  validates :department, presence: true
  validate :check_if_empty_department

  def check_if_empty_department
    errors.add(:department, 'cannot be an empty string') if department.nil? || department == " "
  end

  def can_delete_enrollment?(enrolled_course)
    courses.include?(enrolled_course)
  end
end
