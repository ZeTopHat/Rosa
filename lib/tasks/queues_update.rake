desc "Updating list of Queues"
task :queues_update => :environment do
  puts "Recreating list of Queues.."
  @queues = Group.all
  puts "Creating other queues.."
  # Read in queues from file
  File.open("otherqueues.txt", "r:utf-8") do |content|
    otherqueues_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    # Unless the "other" queue exists in the file, delete the "other" queue object.
    @queues.each do |exists|
      unless exists.ours
        unless otherqueues_content.include?("#{exists.name}")
          exists.destroy 
        end
      end
    end
    # Perform the following actions for each line of the file (Should just be a queue)
    otherqueues_content.each_line do |queuevar|
      # Discards any lines that start with a # sign
      unless ( "#{queuevar}" =~ /^#/)
        # This variable and the following catch/throw is to prevent it from creating duplicate objects
        gate = true
        catch(:stop) do
          @queues.each do |compare|
            if ( compare.name == queuevar.chomp )
              gate = false
              throw :stop
            end
          end
        end
        if gate  
          # Object Creation for "other" queue object
          Group.create(:name => queuevar.chomp, :ours => false)
        end
      end
    end
  end
  puts "Creating team queues.."
  File.open("ourqueues.txt", "r:utf-8") do |content|
    ourqueues_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    # Unless the "our" queue exists in the file, delete the "our" queue object.
    @queues.each do |exists|
      if exists.ours
        unless ourqueues_content.include?("#{exists.name}")
          exists.destroy
        end
      end
    end
    # Perform the following actions for each line of the file (Should just be a queue)
    ourqueues_content.each_line do |queuevar|
      # Discards any lines that start with a # sign
      unless ( "#{queuevar}" =~ /^#/)
        # This variable and the following catch/throw is to prevent it from creating duplicate objects
        gate = true
        catch(:stop) do
          @queues.each do |compare|
            if ( compare.name == queuevar.chomp )
              gate = false
              throw :stop
            end
          end
        end
        if gate
          # Object Creation of the "our" queue
          Group.create(:name => queuevar.chomp, :ours => true)
        end
      end
    end
  end

  puts "done."
end
