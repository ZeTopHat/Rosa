desc "Refresh the taken SRs table"
task :kill_queue => :environment do
  puts "Killing SRs in queue.."
  # Destroy all SR objects in queue
  ServiceRequest.all.each do |request|
    unless request.taken
      puts "Destroying #{request.number}.."
      request.destroy
      puts "#{request.number} destroyed."
    end
  end
  puts "done."
end

