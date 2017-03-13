class CreateTeamusers < ActiveRecord::Migration
  def change
    create_table :teamusers do |t|
      t.integer :team_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :teamusers, [:user_id, :created_at]
  end
end
