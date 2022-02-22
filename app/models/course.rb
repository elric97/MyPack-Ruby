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
  validate :check_if_empty_room
  validate :weekday2_is_not_same_as_weekday1
  validate :end_is_after_start
  validate :check_course_code
  validate :check_waitlist_capacity
  validate :check_if_empty_description, :check_if_empty_name, :check_if_empty_weekday1, :check_if_empty_status, :check_if_empty_course_code

  def end_is_after_start
    errors.add(:endTime, 'cannot be before the start time') if endTime <= startTime
  end

  def weekday2_is_not_same_as_weekday1
    errors.add(:weekday2, 'cannot be same as weekday1') if weekday1 == weekday2
  end

  def check_course_capacity
    errors.add(:capacity, 'cannot be 0 or less') if capacity.nil? || capacity <= 0
  end

  def check_waitlist_capacity
    errors.add(:wlCapacity, 'cannot be null or less than 0') if wlCapacity.nil? || wlCapacity < 0
  end

  def check_if_empty_room
    errors.add(:roomNumber, 'cannot be an empty string') if roomNumber.nil? || roomNumber == " "
  end

  def check_if_empty_description
    errors.add(:description, 'cannot be an empty string') if description.nil? || description == " "
  end

  def check_if_empty_name
    errors.add(:name, 'cannot be an empty string') if name.nil? || name == " "
  end

  def check_if_empty_weekday1
    errors.add(:weekday1, 'cannot be empty ') if weekday1.nil? ||  weekday1 == " "
  end

  def check_if_empty_status
    errors.add(:status, 'cannot be empty ') if status.nil? ||  status == " "
  end

  def check_if_empty_course_code
    errors.add(:courseCode, 'cannot be empty ') if courseCode.nil? ||  courseCode == " "
  end
  def check_course_code
    if nil? || !/\A[a-zA-Z]{3}\d{3}\Z/.match?(courseCode)
      errors.add(:courseCode, 'must have 3 letters followed by 3 digits')
    end
  end

  def can_update_cap?(cap)
    errors.add(:capacity, " can't be less then already enrolled students")
    (cap.to_i - Enrollment.where(course_id: id).count) >= 0
  end

  def can_update_wlcap?(wl_cap)
    errors.add(:wlCapacity, " can't be less then already wait listed students")
    (wl_cap.to_i - Waitlist.where(course_id: id).count) >= 0
  end
end
