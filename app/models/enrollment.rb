class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :course_id, uniqueness: { scope: :student_id, message: 'record already exists' }
end
