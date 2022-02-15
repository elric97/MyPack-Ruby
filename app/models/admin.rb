class Admin < ApplicationRecord
  belongs_to :user

  delegate :name, :email, to: :user, allow_nil: :true
end
