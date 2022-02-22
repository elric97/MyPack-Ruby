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
  validates :phone, presence: true, uniqueness: true, format: { with: /\A\d+\z/, message: "Integer Only" }
  validates :major, presence: true

  validate :check_if_empty_studentID, :check_if_empty_phone, :check_if_empty_major

  def check_if_empty_studentID
    errors.add(:studentID, 'cannot be an empty string') if studentID.nil? || studentID == " "
  end

  def check_if_empty_phone
    errors.add(:phone, 'cannot be an empty string') if phone.nil? || phone == " "
  end

  def check_if_empty_major
    errors.add(:major, 'cannot be an empty string') if major.nil? || major == " "
  end
  def can_delete_enrollment?(enrolled_student_id)
    id == enrolled_student_id
  end
end
