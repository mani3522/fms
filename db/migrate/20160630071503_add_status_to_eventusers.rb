class AddStatusToEventusers < ActiveRecord::Migration
  def change
    add_column :eventusers, :status, :integer
  end
end
