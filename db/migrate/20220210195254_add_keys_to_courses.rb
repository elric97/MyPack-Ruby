class AddKeysToCourses < ActiveRecord::Migration[6.0]
  def change
    add_reference :courses, :instructor, null: false, foreign_key: true
  end
end
