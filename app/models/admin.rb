class Admin < ApplicationRecord
  belongs_to :user
  validates :phone, uniqueness: true, presence: true
end
