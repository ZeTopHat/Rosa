desc "Refresh the Queue"
task :refresh_queue => :environment do
	puts "before session var"
  session = ActionDispatch::Integration::Session.new(Rails.application)
  puts "after session var"
  # This causes the refresh method in the server_request controller to execute
  puts "before get request"
  session.get "/service_request/refresh"
  puts "after get request"
end
