#!/home/vinay/.rvm/rubies/ruby-2.1.2/bin/ruby
# rain.rb

require_relative "dbmock"

#define & declare class level variables
@action = 6
@dbmock_instance = Dbmock.new

puts "Welcome to RecruiterSoft."
puts "Enter your database (YAML,JSON,MARSHAL or MYSQL):"
$storage_arg = gets.chomp.to_s.upcase

#Load from respective database
if $storage_arg == "JSON"
  $hash_recruiters = @dbmock_instance.json_get()
elsif $storage_arg == "YAML"
  $hash_recruiters = @dbmock_instance.yaml_get()
elsif $storage_arg == "MYSQL"
  $hash_recruiters = @dbmock_instance.mysql_get()
else
  $hash_recruiters = @dbmock_instance.marshal_get()
end

puts "\n"
while @action != 5

  puts "Enter your option:"
  puts "1. Add"
  puts "2. View"
  puts "3. Update"
  puts "4. Delete"
  puts "5. Exit"
  puts "\n"

  #read the user input
  @action = gets.chomp.to_i
  puts "\n"
  #puts "#{@action.to_s} is performed"

  case @action

    when 1
      puts "Enter recruiter name:"
      recruiter_name = gets.chomp.to_s
      puts "Enter recruiter email:"
      recruiter_email = gets.chomp.to_s
      puts "Enter recruiter zip:"
      recruiter_zip = gets.chomp.to_s
      @dbmock_instance.add_recruiter(Recruiter.new(recruiter_name,recruiter_email,recruiter_zip))
      puts "Successfully added."
      puts "\n"

    when 2

      if $storage_arg == "MYSQL"
        $hash_recruiters = @dbmock_instance.mysql_get()
      end

      if ($hash_recruiters.length == 0)
        puts "No records of recruiters."
      else
        $hash_recruiters.each {
            |key,value|
            puts "#{key.to_s} is #{value.Name.to_s}, #{value.Email.to_s} - #{value.Zip.to_s}"
        }
        puts "Displayed all recruiters."
      end

      puts "\n"

    when 3
      puts "Enter recruiter ID:"
      recruiter_id = gets.chomp.to_i

      update_recruiter_instance = @dbmock_instance.view_recruiter(recruiter_id)
      if update_recruiter_instance == nil
        puts "Invalid recruiter ID."
      else
        puts "Selected recruiter is #{update_recruiter_instance.Name}"

        puts "Enter recruiter name:"
        recruiter_name = gets.chomp.to_s
        puts "Enter recruiter email:"
        recruiter_email = gets.chomp.to_s
        puts "Enter recruiter zip:"
        recruiter_zip = gets.chomp.to_s

        @dbmock_instance.update_recruiter(recruiter_id,Recruiter.new(recruiter_name,recruiter_email,recruiter_zip))

        puts "Successfully updated in Hash."
      end
      puts "\n"

    when 4
      puts "Enter recruiter ID:"
      recruiter_id = gets.chomp.to_i
      if (@dbmock_instance.delete_recruiter(recruiter_id) == true)
        puts "Successfully deleted."
      else
        puts "Invalid recruiter ID."
      end
      puts "\n"

    when 5
      #just ignore to quit the options

    else
      puts "Specify valid option"
  end
end

  #Store to respective database
  if $storage_arg == "JSON"
    @dbmock_instance.json_put($hash_recruiters)
  elsif $storage_arg == "YAML"
    @dbmock_instance.yaml_put($hash_recruiters)
  elsif $storage_arg == "MYSQL"
    #ignore mysql, as we are doing runtime saving to DB
  else
    @dbmock_instance.marshal_put($hash_recruiters)
  end

puts "Thank you for using RecruiterSoft."