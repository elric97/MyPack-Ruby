class AddKeyToInstructor < ActiveRecord::Migration[6.0]
  def change
    add_reference :instructors, :user, null: false, foreign_key: true
  end
end
