json.extract! course, :id, :name, :meeting_week, :created_at, :updated_at
json.url course_url(course, format: :json)
