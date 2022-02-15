class Student < ApplicationRecord
  belongs_to :user
  has_many :enrollments
  has_many :courses, through: :enrollments
  # has_many :waitlists
  validates :studentID, uniqueness: true, presence: true
  validates :DOB, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :major, presence: true
end
