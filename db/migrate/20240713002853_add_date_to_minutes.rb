class AddDateToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_column :minutes, :date, :date
  end
end
