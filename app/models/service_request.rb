class ServiceRequest < ActiveRecord::Base
  belongs_to :username
  validates :number, :presence => true
  # Eventually I should have some sort of validation for all vars of ServiceRequest objects/attributes: number, briefdes, longdes, lastact, lastactstamp, locale, priority, hours, contactvia, queue, entitlement, Account, returned
end
