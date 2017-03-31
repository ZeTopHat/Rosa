desc "Refresh the taken SRs table"
task :kill_queue => :environment do
  puts "Killing SRs in queue.."
  # Destroy all SR objects in queue
  ServiceRequest.all.each do |request|
    unless request.taken
      request.destroy
    end
  end
  puts "done."
end

