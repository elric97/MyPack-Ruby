class Student < ApplicationRecord
  belongs_to :user
  has_many :enrollments
  has_many :courses, through: :enrollments, dependent: :destroy

  has_many :waitlists
  has_many :courses, through: :waitlists, dependent: :destroy

  # has_many :waitlists
  validates :studentID, uniqueness: true, presence: true
  delegate :name, :email, to: :user, allow_nil: :true
  validates :DOB, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :major, presence: true
end
