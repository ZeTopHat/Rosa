desc "Refresh the service requests in the database"
task :refresh_srs => :environment do
  # includes
  require 'open-uri'
  require 'json'
   
    
  puts "Refreshing service request objects in the database.."
  ServiceRequest.all.each do |request|
  
    # importing json confidentials
    conf_file = File.open("config/confidential.json", "r:utf-8").read
    conf_json = JSON.parse(conf_file)

    # pull down SR content for updates. Array to hash in order to take care of html crap. (why couldn't it be json?? (╯°□°)╯︵ ┻━┻)
    read_content = open("#{$conf_json['sr_info']}#{request.number}", "r:utf-8").read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    content_array = read_content.split("<HTML>\r\n   ", 2)[1].split("<br>")
    sr_content = Hash[content_array.map { |item| item.split(" = ", 2) }]

    # unless the rosa db still matched the proetus db, update the rosa db to match the proetus db
  
    sr_references = Hash[ request.lastact => "X_LAST_ACT_COMMENT", request.lastactstamp => "ACTL_RESP_TS", request.username => "LOGIN", request.priority => "SR_SEVERITY", request.contactvia => "X_RESPOND_VIA", request.locale => "ORG"]

    sr_references.each do |key, value|
      if (key == request.username)
        if request.taken && !( key.name == sr_content["#{value}"])
          puts "It saw that #{request.number} no longer matches in ownership - Destroying #{request.number}"
          request.destroy
          puts "#{request.number} destroyed."
        end
      else
        unless ( key == sr_content["#{value}"] )
          puts "Updating #{request.number} #{key}"
          request.update_attribute(:key, sr_content["#{value}"])
          puts "#{key} updated."
        end
      end
    end
  end
  puts "Done."
end
