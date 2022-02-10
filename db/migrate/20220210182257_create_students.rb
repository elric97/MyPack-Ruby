class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :studentID
      t.date :DOB
      t.string :phone
      t.string :major

      t.timestamps
    end
  end
end
