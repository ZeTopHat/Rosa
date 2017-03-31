desc "Updating list of Users"
task :users_update => :environment do
  puts "Recreating list of Users.."
  #@usernames = Username.all
  # Read in users from file
  File.open("usernames.txt", "r:utf-8") do |content|
    usernames_content = content.read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    # Delete all users in the database, this is so that users are added based on the order given in the usernames.txt file
    Username.all.each do |exists|
      exists.destroy
    end
    # Perform the following actions for each line of the file (Should just be a username)
    usernames_content.each_line do |uservar|
      # Discards any lines that start with a # sign
      unless ( "#{uservar}" =~ /^#/)
        # This variable and the following catch/throw is to prevent it from creating duplicate objects
        gate = true
        catch(:stop) do
          Username.all.each do |compare|
            if ( compare.name == uservar.chomp )
              gate = false
              throw :stop
            end
          end
        end
        if gate
          # Object Creation of user
          Username.create(:name => uservar.chomp)
        end
      end
    end
  end
  puts "done."
end
