class CreatedAtS < ActiveRecord::Migration
  def change
    add_column :service_requests, :created_at, :datetime
  end
end
