class CreateHiatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :hiatuses do |t|
      t.references :member, null: false, foreign_key: true
      t.date :finished_at

      t.timestamps
    end
  end
end
