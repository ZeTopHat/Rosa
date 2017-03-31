class ServiceRequestController < ApplicationController
  # includes
  require 'open-uri'
  require 'json'

  # importing json confidentials
  conf_file = File.open("config/confidential.json", "r:utf-8").read
  $conf_json = JSON.parse(conf_file)

  # Password protect certain actions
  http_basic_authenticate_with name: "#{$conf_json["username"]}", password: "#{$conf_json["password"]}", :only => ['new', 'delete']

  # Index page action
  def index
  end

  def initqmon
    qmonscope = Array.new
    Group.all.each do |queue|
      if queue.ours
        qmonscope << queue.name
      end
    end
    # System command to generate queue file
    `for i in #{qmonscope.join(" ")} ; do qmon -qv $i ; done | awk '{ print $2}' >app/assets/data/queue`
  end

  def trimqueue(content)
    # Destroy any service requests not taken by someone in the database or that isn't in the queue
    ServiceRequest.all.each do |exists|

      unless exists.taken || content.include?("#{exists.number}")
        exists.destroy
      end

    end
  end

  def checkgate(sr_number)
    # Discards any lines that aren't only numbers
    if ( "#{sr_number}" =~ /^[0-9]+$/)
      # Create an array of existing SR numbers to compare and avoid duplicates
      srnum = []
      ServiceRequest.all.each do |num|
        srnum << num.number
      end
      if srnum.include?(sr_number.to_i)
        $gate = false
      end
    else
      $gate = false
    end
  end

  # Refresh action. This is called by the refresh_queue rake task and generates the queue
  def refresh

    # Objects
    @service_requests = ServiceRequest.all

    initqmon()

    queue_content = ""
    # Read from file just created
    File.open("app/assets/data/queue", "r:utf-8") do |r|
      queue_content = r.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    end

    trimqueue(queue_content)

    # Perform the following actions for each line of the file (ideally each SR number)
    queue_content.each_line do |srnum|
      $gate = true

      checkgate(srnum)

      if $gate

# rather than mulitple array variables and honed array variables, create one array variable based on the <thml> tage at beginning, and one honed veriable based on <br> and use all items with one array. Eventaully rather than depending on the array order, use the = sign to split and convert each item into a hash with the key and value

        # Creating variables outside of their blocks so the variables have a wider scope than their blocks and can be used in the creation of the object
        honed_desarray = []
        honed_barray = []
        honed_stamparray = []
        honed_crestamparray = []
        honed_localearray = []
        honed_entitlementarray = []
        honed_priorityarray = []
        honed_queuearray = []
        honed_accountarray = []
        honed_hoursarray = []
        honed_contactarray = []
        returnedvar = false
        ltssvar = false
        sr_info = ""
        
        uri = open("#{$conf_json['sr_info']}#{srnum}", "r:utf-8") do |content|
          # Grabbing longdes and lastact variables
          read_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
          desarray = read_content.split("DESC_TEXT = ")
          honed_desarray = desarray[1].split("X_LAST_ACT_COMMENT = ")
          # There is not always a Last Act Comment, this is to avoid an error in the creation of the object
          if honed_desarray[1].nil?
            honed_desarray[1] = ""
          end

          # Grabbing briefdes
          barray = read_content.split("SR_TITLE = ")
          honed_barray = barray[1].split("<br>")
          # Last Act Stamp
          stamparray = read_content.split("ACTL_RESP_TS = ")
          honed_stamparray = stamparray[1].split("<br>")
          # Locale
          localearray = read_content.split("ORG = ")
          honed_localearray = localearray[1].split("<br>")
          # Created Stamp
          crestamparray = read_content.split("CREATED = ")
          honed_crestamparray = crestamparray[1].split("<br>")
          # Entitlement
          entitlementarray = read_content.split("X_SUPPORT_PROG = ")
          honed_entitlementarray = entitlementarray[1].split("<br>")
          # priority
          priorityarray = read_content.split("SR_SEVERITY = ")
          honed_priorityarray = priorityarray[1].split("<br>")
          # queue
          queuearray = read_content.split("LOGIN = ")
          honed_queuearray = queuearray[1].split("<br>")
          # account
          accountarray = read_content.split("ACCOUNT_NAME = ")
          honed_accountarray = accountarray[1].split("<br>")
          # hours
          hoursarray = read_content.split("SUPPORT_HOURS = ")
          honed_hoursarray = hoursarray[1].split("<br>")
          # contactvia
          contactarray = read_content.split("X_RESPOND_VIA = ")
          honed_contactarray = contactarray[1].split("<br>")
        end

        uri = open("#{$conf_json["returning_info"]}", "r:utf-8", {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) do |content|
          # Returned boolean
          read_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
          unless read_content.include?("#{srnum.chomp}")
            returnedvar = true
          end
        end
        uri = open("#{$conf_json["ltss_info"]}", "r:utf-8", {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) do |content|
          # Compare for LTSS boolean
          read_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
          if read_content.include?("#{honed_accountarray[0]}")
            ltssvar = true
          end
        end

        # check for Lock file
        unless File.exist?("app/assets/data/#{srnum.chomp}lock")
          # Create Lock file to prevent duplicates being created
          File.new("app/assets/data/#{srnum.chomp}lock", "w")

          # Current Time
          created_at = Time.now

          # Object Creation
          ServiceRequest.create(:number => srnum, :briefdes => honed_barray[0], :longdes => honed_desarray[0], :lastact => honed_desarray[1], :lastactstamp => honed_stamparray[0], :queue => honed_queuearray[0], :priority => honed_priorityarray[0], :hours => honed_hoursarray[0], :contactvia => honed_contactarray[0], :locale => honed_localearray[0], :account => honed_accountarray[0], :returned => returnedvar, :ltss => ltssvar, :createdstamp => honed_crestamparray[0], :entitlement => honed_entitlementarray[0], :created_at => created_at)

          # Destroy Lock file
          File.delete("app/assets/data/#{srnum.chomp}lock")
          #redirect_to :action => 'index'
        end
      end
    end
    redirect_to :action => 'index'
  end

  # This is for the lists page used for testing. Can be accessed directly, but is not linked to from any other pages.
  def list
    @service_requests = ServiceRequest.all
  end

  # Action for the show page
  def show
    @service_request = ServiceRequest.find(params[:id])
  end

  # Action for new page (password protected)
  def new
    @service_request = ServiceRequest.new
    @usernames = Username.all
  end

  # This is for creating and saving to the database. One step more than new
  def create
    @service_request = ServiceRequest.new(service_request_params)

    if @service_request.save
      redirect_to :action => 'list'
    else
      @usernames = Username.all
      render :action => 'new'
    end
  end

  # To assign SRs
  def edit
    @service_request = ServiceRequest.find(params[:id])
    @usernames = Username.all
  end

  # This is for updating the user attributes. Currently only use is to update the reason for not being available to take SRs. It will display that reason on the SRs Taken page.
  def userupdate
    @username = Username.find(params[:id])

    if @username.update_attributes(username_param)
      redirect_to :action => 'index'
    else
      @usernames = Username.all
      render :action => 'edit'
    end
  end

  # Main update function. Used for updating the SR. Needed for assigning SRs and changing various attributes of objects
  def update

    @service_request = ServiceRequest.find(params[:id])

    # Before a username update will go through it checks to make sure it hasn't already been taken by checking back with the siebel database and comparing to the rosa database.
    honed_ownarray = []
    uri = open("#{$conf_json["sr_info"]}#{@service_request.number}") do |content|
      read_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
      ownarray = read_content.split("LOGIN = ")
      honed_ownarray = ownarray[1].split("<br>")
    end

    # If the object's queue name and the queue name from proetus(siebel db) match it will continue
    if ( @service_request.queue == honed_ownarray[0] )
      # If the SR's taken boolean is set to true it can't proceed with the update.
      if @service_request.taken
        render :action => 'SR404'
      else
        # After comparing the queue and seeing if it is taken, it now applies the requested changes, and then continues based on new attributes set.
        if @service_request.update_attributes(service_request_param)
        noqueue = false
          # If the SR has been set to unassign it means the move form has been executed and it needs to go back into a queue.
          if @service_request.unassign
            if (!@service_request.queue.present?)
              @service_request.update_attribute(:unassign, false)
              render :action => 'noqueue'
              noqueue = true
            else
              # Assign to the queue
              command = "w3m -dump #{$conf_json["assign_info"]}#{@service_request.number}\\&owner=#{@service_request.queue}\\&force=1"
              system(command)
              # Set taken to false since no one owns it anymore.
              @service_request.update_attribute(:taken, false)
              # Build an array of queues that are set as "ours"
              grouparray = Array.new
              Group.all.each do |queue|
                if queue.ours
                  grouparray << queue.name
                end
              end
            end
            unless noqueue
              # if the queue it's been set to is "ours" it will set unassign to false so that it will show back up in our queue.
              # if the queue is not "ours" it will keep unassign as true so that it doesn't show in our queue. Eventually the refresh_queue task will destroy it from the db.
              if grouparray.include?(@service_request.queue)
                @service_request.update_attribute(:unassign, false)
              else
                # If it is not our queue and it's being moved successfully, check email booleans to see if an email needs to be sent
                if @service_request.emailsla
                  AutomatedEmail.outside_sla(@service_request).deliver_now
                end
                if @service_request.emailpriority
                  AutomatedEmail.low_priority(@service_request).deliver_now
                end
              end
              redirect_to :action => 'index'
            end
          elsif (!@service_request.username_id.present?)
            render :action => 'nouser'
          else
            # If it's not set to "unassign" then the assign form was executed and we set taken to true and assign the user to the request.
            @service_request.update_attribute(:taken, true)
            command = "w3m -dump #{$conf_json["assign_info"]}#{@service_request.number}\\&owner=#{@service_request.username.name}\\&force=1"
            system(command)
            redirect_to :action => 'show', :id => @service_request
          end
        # error during update attribute save
        else
          @usernames = Username.all
          render :action => 'edit'
        end
      end
    # if the SR has already been taken it sends to the SR404 page
    else
      # Builds an array of all the users in the database
      userarray = Array.new
      Username.all.each do |user|
        userarray << user.name
      end
      # if the mismatch is because the siebeldb entry matches a user, we simply redirect to the 404
      if userarray.include?(honed_ownarray[0])
        render :action => 'SR404'
      # if the mismatch is not because the siebel db entry matches a user, we updates the queue. This is to prevent locking issues if someone changes an SRs queue through siebel. In this situation Rosa needs to update its information.
      else
        @service_request.update_attribute(:queue, honed_ownarray[0])
        render :action => 'SR404'
      end
    end
  end

  # Used by the Move page and form
  def move
    @service_request = ServiceRequest.find(params[:id])
    @usernames = Username.all
  end

  # This is an option available through the lists page. This is also password protected.
  def delete
    ServiceRequest.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  # Show page for usernames
  def show_usernames
    @username = Username.find(params[:id])
  end

  # Private definitions for parameter requirements
  private
    def service_request_params
      params.require(:service_requests).permit(:number, :briefdes, :username_id, :taken, :returned, :queue, :unassign, :emailsla, :emailpriority)
    end

    def service_request_param
      params.require(:service_request).permit(:number, :briefdes, :username_id, :taken, :returned, :queue, :unassign, :emailsla, :emailpriority)
    end

    def username_param
      params.require(:username).permit(:excuse)
    end

    def username_params
      params.require(:usernames).permit(:excuse)
    end

end
