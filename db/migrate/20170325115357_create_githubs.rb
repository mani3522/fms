class CreateGithubs < ActiveRecord::Migration
  def change
    create_table :githubs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
