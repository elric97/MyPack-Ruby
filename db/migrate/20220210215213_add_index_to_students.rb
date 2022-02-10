class AddIndexToStudents < ActiveRecord::Migration[6.0]
  def change
    add_index :students, :studentID, unique: true
  end
end
