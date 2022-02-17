class Waitlist < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :course_id, uniqueness: { scope: :student_id, message: 'Already waitlisted in this course' }
  validate :check_if_enrolled

  def check_if_enrolled
    @enrollment = Enrollment.where('course_id = ? AND student_id = ?', course_id, student_id)
    errors.add(:student_id, 'Already enrolled in this course') unless @enrollment.first.nil?
  end
end

