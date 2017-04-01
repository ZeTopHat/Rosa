desc "Updating list of Queues"
task :queues_update => :environment do
  puts "Recreating list of Queues.."
  @queues = Group.all

  puts "Creating other queues.."
  # Read in queues from file
  otherqueues_content = File.open("otherqueues.txt", "r:utf-8").read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
  # Unless the queue is an "our" queue or exists in the otherqueue file, delete the "other" queue object.
  @queues.each do |exists|
    unless exists.ours || otherqueues_content.include?("#{exists.name}")
      puts "#{exists.name} is not a team queue and is not listed in the otherqueues.txt. Destroying.."
      exists.destroy
      puts "Destroyed #{exists.name}."
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
            puts "#{queuevar} already exists as an other queue. Skipping.."
            gate = false
            throw :stop
          end
        end
      end
    end
    if gate  
      # Object Creation for "other" queue object
      puts "Creating #{queuevar} as an other queue.."
      Group.create(:name => queuevar.chomp, :ours => false)
      puts "#{queuevar} created."
    end
  end

  puts "Creating team queues.."
  ourqueues_content = File.open("ourqueues.txt", "r:utf-8").read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
  # if the queue is an "our" queue and doesn't exist in the file, delete the "our" queue object.
  @queues.each do |exists|
    if exists.ours && !ourqueues_content.include?("#{exists.name}")
      puts "#{exists.name} exists as a team queue but is not listed in the ourqueues.txt. Destroying.."
      exists.destroy
      puts "Destroyed #{exists.name}."
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
            puts "#{queuevar} already exists as a team queue. Skipping.."
            gate = false
            throw :stop
          end
        end
      end
    end
    if gate
      # Object Creation of the "our" queue
      puts "Creating #{queuevar} as a team queue.."
      Group.create(:name => queuevar.chomp, :ours => true)
      puts "#{queuevar} created."
    end  
  end

  puts "done."
end
