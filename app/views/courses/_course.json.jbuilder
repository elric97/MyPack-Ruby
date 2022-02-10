json.extract! course, :id, :name, :description, :weekday1, :weekday2, :startTime, :endTime, :courseCode, :capacity, :wlCapacity, :status, :roomNumber, :created_at, :updated_at
json.url course_url(course, format: :json)
