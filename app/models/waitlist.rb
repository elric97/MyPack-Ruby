class Waitlist < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :course_id, uniqueness: { scope: :student_id, message: 'record already exists' }
  validate :check_if_enrolled

  def check_if_enrolled
    @enrollment = Enrollment.where('course_id = ? AND student_id = ?', course_id, student_id)
    errors.add(:course_id, 'Already enrolled') unless @enrollment.first.nil?
  end
end

