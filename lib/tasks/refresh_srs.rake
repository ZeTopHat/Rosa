desc "Refresh the service requests in the database"
task :refresh_srs => :environment do
  # includes
  require 'open-uri'
  require 'json'

  # importing json confidentials
  conf_file = File.open("config/confidential.json", "r:utf-8").read
  conf_json = JSON.parse(conf_file)

  puts "Refreshing service request objects in the database.."
  ServiceRequest.all.each do |request|
    # Get updated Queue information for each SR
    honed_desarray = []
    honed_stamparray = []
    honed_queuearray = []
    honed_contactarray = []
    honed_priorityarray = []
    honed_localearray = []
    uri = open("#{conf_json["sr_info"]}#{request.number}") do |content|
      read_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
      # last act
      desarray = read_content.split("DESC_TEXT = ")
      honed_desarray = desarray[1].split("X_LAST_ACT_COMMENT = ")
      # There is not always a Last Act Comment, this is to avoid an error in the creation of the object
      if honed_desarray[1].nil?
        honed_desarray[1] = ""
      end
      # Last Act Stamp
      stamparray = read_content.split("ACTL_RESP_TS = ")
      honed_stamparray = stamparray[1].split("<br>")
      # Locale
      localearray = read_content.split("ORG = ")
      honed_localearray = localearray[1].split("<br>")
      # Queue
      queuearray = read_content.split("LOGIN = ")
      honed_queuearray = queuearray[1].split("<br>")
      # contactvia
      contactarray = read_content.split("X_RESPOND_VIA = ")
      honed_contactarray = contactarray[1].split("<br>")
      # priority
      priorityarray = read_content.split("SR_SEVERITY = ")
      honed_priorityarray = priorityarray[1].split("<br>")
    end

    # unless the rosa db still matched the proetus db, update the rosa db to match the proetus db
    unless ( request.lastact == honed_desarray[1] )
      puts "Updated #{request.number} last act"
      request.update_attribute(:lastact, honed_desarray[1])
    end
    unless ( request.lastactstamp == honed_stamparray[0] )
      puts "Updated #{request.number} last act stamp"
      request.update_attribute(:lastactstamp, honed_stamparray[0])
    end
    if request.taken
      unless ( request.username.name == honed_queuearray[0] )
        puts "It saw that #{request.number} no longer matches in ownership - Destroying #{request.number}"
        request.destroy
      end
    end
    unless ( request.priority == honed_priorityarray[0] )
      puts "Updated #{request.number} priority"
      request.update_attribute(:priority, honed_priorityarray[0])
    end
    unless ( request.contactvia == honed_contactarray[0] )
      puts "Updated #{request.number} contact method"
      request.update_attribute(:contactvia, honed_contactarray[0] )
    end
    unless ( request.locale == honed_localearray[0] )
      puts "Updated #{request.number} locale"
      request.update_attribute(:locale, honed_localearray[0] )
    end
  end
  puts "Done."
end
