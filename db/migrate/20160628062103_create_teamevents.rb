class CreateTeamevents < ActiveRecord::Migration
  def change
    create_table :teamevents do |t|
      t.integer :team_id
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
