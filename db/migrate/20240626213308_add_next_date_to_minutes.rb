class AddNextDateToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_column :minutes, :next_date, :date
  end
end
