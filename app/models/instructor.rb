class Instructor < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  delegate :name, :email, to: :user, allow_nil: :true
  validates :department, presence: true

  def can_delete_enrollment?(enrolled_course)
    courses.include?(enrolled_course)
  end
end
