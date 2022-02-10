class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :weekday1
      t.string :weekday2
      t.time :startTime
      t.time :endTime
      t.string :courseCode
      t.integer :capacity
      t.integer :wlCapacity
      t.string :status
      t.string :roomNumber

      t.timestamps
    end
  end
end
