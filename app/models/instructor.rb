class Instructor < ApplicationRecord
  belongs_to :user
  has_many :courses
  delegate :name, :email, to: :user, allow_nil: :true
end
