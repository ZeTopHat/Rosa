class ServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :createdstamp, :varchar
  end
end
