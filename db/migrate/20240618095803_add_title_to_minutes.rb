class AddTitleToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_column :minutes, :title, :string
  end
end
