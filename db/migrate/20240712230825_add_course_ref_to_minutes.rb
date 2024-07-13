class AddCourseRefToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_reference :minutes, :course, null: false, foreign_key: true
  end
end
