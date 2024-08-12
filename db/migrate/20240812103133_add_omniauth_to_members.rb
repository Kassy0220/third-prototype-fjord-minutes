class AddOmniauthToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :provider, :string
    add_column :members, :uid, :string
  end
end
