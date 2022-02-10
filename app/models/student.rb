class Student < ApplicationRecord
  belongs_to :user
  validates :studentID, uniqueness: true, presence: true
end
