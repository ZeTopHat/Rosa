desc "Refresh the taken SRs table"
task :refresh_taken => :environment do
  puts "Refreshing SRs Taken table.."
  # Destroy all SR objects in anticipation of the next day to start new
  ServiceRequest.all.each do |request|
    if request.taken
      request.destroy
    end
  end
  puts "done."
end

