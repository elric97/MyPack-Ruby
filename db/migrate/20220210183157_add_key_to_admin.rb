class AddKeyToAdmin < ActiveRecord::Migration[6.0]
  def change
    add_reference :admins, :user, null: false, foreign_key: true
  end
end
