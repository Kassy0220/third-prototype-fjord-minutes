class AddUniqueIndexToMinutesCourseIdAndDate < ActiveRecord::Migration[7.1]
  def change
    add_index :minutes, [:course_id, :date], unique: true
  end
end
