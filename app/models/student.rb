class Student < ApplicationRecord
  belongs_to :user
  has_many :enrollments
  has_many :courses, through: :enrollments
  # has_many :waitlists
  validates :studentID, uniqueness: true, presence: true
  delegate :name, :email, to: :user, allow_nil: :true
end
