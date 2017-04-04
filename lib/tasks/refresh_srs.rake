desc "Refresh the service requests in the database"
task :refresh_srs => :environment do
  # includes
  require 'open-uri'
  require 'json'

  # importing json confidentials
  conf_file = File.open("config/confidential.json", "r:utf-8") { |f| f.read }
  conf_json = JSON.parse(conf_file)


  puts "Refreshing service request objects in the database.."
  ServiceRequest.all.each do |request|

    # Get existing information for SR from db
    read_content = open("#{conf_json['sr_info']}#{request.number}", "r:utf-8") { |f| f.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil) }
    content_array = read_content.split("<HTML>\r\n   ", 2)[1].split("<br>")
    sr_content = Hash[content_array.map { |item| item.split(" = ", 2) }]

    # Get most up to date information for SR from proetus db
    read_content = open("#{conf_json["sr_info"]}#{request.number}") { |f| f.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil) }

    # unless the rosa db still matched the proetus db, update the rosa db to match the proetus db
    unless ( request.lastact == sr_content["X_LAST_ACT_COMMENT"] )
      puts "Updated #{request.number} last act"
      request.update_attribute(:lastact, sr_content["X_LAST_ACT_COMMENT"])
    end
    unless ( request.lastactstamp == sr_content["ACTL_RESP_TS"] )
      puts "Updated #{request.number} last act stamp"
      request.update_attribute(:lastactstamp, sr_content["ACTL_RESP_TS"])
    end
    if request.taken && !( request.username.name == sr_content["LOGIN"] )
      puts "It saw that #{request.number} no longer matches in ownership - Destroying #{request.number}"
      request.destroy
    end
    unless ( request.priority == sr_content["SR_SEVERITY"] )
      puts "Updated #{request.number} priority"
      request.update_attribute(:priority, sr_content["SR_SEVERITY"])
    end
    unless ( request.contactvia == sr_content["X_RESPOND_VIA"] )
      puts "Updated #{request.number} contact method"
      request.update_attribute(:contactvia, sr_content["X_RESPOND_VIA"] )
    end
    unless ( request.locale == sr_content["ORG"] )
      puts "Updated #{request.number} locale"
      request.update_attribute(:locale, sr_content["ORG"] )
    end
  end
  puts "Done."
end
