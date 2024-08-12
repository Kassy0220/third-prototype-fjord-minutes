class AddColumnsToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :name, :string
    add_column :members, :avatar_url, :string
  end
end
