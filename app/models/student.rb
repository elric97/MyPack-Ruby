class Student < ApplicationRecord
  belongs_to :user
  has_many :enrollments
  has_many :waitlists
  validates :studentID, uniqueness: true, presence: true
end
