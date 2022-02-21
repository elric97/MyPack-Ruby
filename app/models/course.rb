class Course < ApplicationRecord
  belongs_to :instructor
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  has_many :waitlists, dependent: :destroy
  has_many :students, through: :waitlists

  # has_many :waitlists
  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :weekday1, presence: true
  validates :weekday2, presence: false
  validates :startTime, presence: true
  validates :endTime, presence: true
  validates :courseCode, uniqueness: true, presence: true
  validates :capacity, presence: true, allow_nil: false
  validates :wlCapacity, presence: true
  validates :status, presence: true
  validates :roomNumber, presence: true

  validate :check_course_capacity
  validate :check_if_empty
  validate :weekday2_is_not_same_as_weekday1
  validate :end_is_after_start
  validate :check_course_code

  def end_is_after_start
    errors.add(:endTime, 'cannot be before the start time') if endTime <= startTime
  end

  def weekday2_is_not_same_as_weekday1
    errors.add(:weekday2, 'cannot be same as weekday1') if weekday1 == weekday2
  end

  def check_course_capacity
    errors.add(:capacity, 'cannot be 0 or less') if capacity.nil? || capacity <= 0
  end

  def check_if_empty
    errors.add(:roomNumber, 'cannot be an empty string') if nil? || roomNumber == " "
  end

  def check_course_code
    errors.add(:courseCode, 'must have 3 letters followed by 3 digits') if courseCode !=~ /\A[a-z]{3}\d{3}\Z/
  end
end
