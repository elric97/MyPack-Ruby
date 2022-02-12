class Course < ApplicationRecord
  belongs_to :instructor
  has_many :enrollments
  has_many :students, through: :enrollments
  # has_many :waitlists
end
