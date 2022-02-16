class Admin < ApplicationRecord
  belongs_to :user
  delegate :name, :email, to: :user, allow_nil: :true
  validates :phone, uniqueness: true, presence: true
end
