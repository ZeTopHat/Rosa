desc "Refresh the Queue"
task :refresh_queue => :environment do
  session = ActionDispatch::Integration::Session.new(Rails.application)
  # This causes the refresh method in the server_request controller to execute
  session.get "/service_request/refresh"
end
