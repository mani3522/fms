class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :empid
      t.date :dateofbirth
      t.string :gender

      t.timestamps null: false
    end
  end
end
