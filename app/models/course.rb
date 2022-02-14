class Course < ApplicationRecord
  belongs_to :instructor
  has_many :enrollments
  has_many :students, through: :enrollments
  # has_many :waitlists
  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :weekday1, presence: true
  validates :weekday2, presence: false
  validates :startTime, presence: true
  validates :endTime, presence: true
  validates :courseCode, uniqueness: true, presence: true
  validates :capacity, presence: true
  validates :wlCapacity, presence: true
  validates :status, presence: true
  validates :roomNumber, presence: true

  validate :check_course_capacity
  validate :check_if_empty
  validate :weekday2_is_not_same_as_weekday1
  validate :endTime_is_after_startTime

  def endTime_is_after_startTime
    if endTime <= startTime
      errors.add(:endTime, 'cannot be before the start time')
    end
  end

  def weekday2_is_not_same_as_weekday1
    if weekday1 == weekday2
      errors.add(:weekday2, 'cannot be same as weekday1')
    end
  end
  def check_course_capacity
    if capacity <= 0
      errors.add(:capacity, 'cannot be 0 or less')
    end
  end
  def check_if_empty
    if roomNumber == " "
      errors.add(:roomNumber, 'cannot be an empty string')
    end
  end

end
