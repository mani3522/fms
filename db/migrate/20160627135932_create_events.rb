class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :startime
      t.datetime :endtime
      t.integer :amount
      t.string :venue

      t.timestamps null: false
    end
  end
end
