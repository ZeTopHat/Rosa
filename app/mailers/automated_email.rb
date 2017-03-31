class AutomatedEmail < ApplicationMailer
  default from: 'rni.suse@gmail.com'

  def outside_sla(sr)
    @service_request = sr
    mail(to: 'support@novell.com', subject: "SR# #{@service_request.number} +EO")
  end

  def low_priority(sr)
    @service_request = sr
    mail(to: 'support@novell.com', subject: "SR# #{@service_request.number} +EO")
  end

end
