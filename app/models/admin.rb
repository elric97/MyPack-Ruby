class Admin < ApplicationRecord
  belongs_to :user
  delegate :name, :email, to: :user, allow_nil: :true
  validates :phone, uniqueness: true, presence: true, format: { with: /\A\d+\z/, message: "Integer Only" }

  def check_if_empty_phone
    errors.add(:phone, 'cannot be an empty string') if nil? || phone == " "
  end
end
