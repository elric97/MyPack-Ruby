class AddKeysToWaitlists < ActiveRecord::Migration[6.0]
  def change
    add_reference :waitlists, :course, null: false, foreign_key: true
    add_reference :waitlists, :student, null: false, foreign_key: true
  end
end
