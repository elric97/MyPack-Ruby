class Student < ApplicationRecord
  belongs_to :user
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments

  has_many :waitlists, dependent: :destroy
  has_many :courses, through: :waitlists

  # has_many :waitlists
  validates :studentID, uniqueness: true, presence: true
  delegate :name, :email, to: :user, allow_nil: :true
  validates :DOB, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :major, presence: true

  def can_delete_enrollment?(enrolled_student_id)
    id == enrolled_student_id
  end
end
