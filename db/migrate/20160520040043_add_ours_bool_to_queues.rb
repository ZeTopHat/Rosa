class AddOursBoolToQueues < ActiveRecord::Migration
  def change
    add_column :groups, :ours, :boolean, :default => false
  end
end
