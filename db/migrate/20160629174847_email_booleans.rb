class EmailBooleans < ActiveRecord::Migration
  def change
    add_column :service_requests, :emailsla, :boolean, :default => false
    add_column :service_requests, :emailpriority, :boolean, :default => false
  end
end
