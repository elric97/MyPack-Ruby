class Instructor < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  delegate :name, :email, to: :user, allow_nil: :true
end
