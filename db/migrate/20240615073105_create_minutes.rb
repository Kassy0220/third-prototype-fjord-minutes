class CreateMinutes < ActiveRecord::Migration[7.1]
  def change
    create_table :minutes do |t|
      t.string :release_branch
      t.string :release_note

      t.timestamps
    end
  end
end
