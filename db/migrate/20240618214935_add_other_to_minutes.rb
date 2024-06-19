class AddOtherToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_column :minutes, :other, :text
  end
end
