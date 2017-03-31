class Username < ActiveRecord::Base
  has_many :service_requests
  validates_presence_of :name
end
