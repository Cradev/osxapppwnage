#!/usr/bin/env ruby -wKU
#
# Description: Generate osascript code to create pop-up boxes requesting password.
# Author: Daniel Phillips
# System: OS X
# 

puts "Please enter Application path: "
path = gets.chomp

# Me has clipboard?
def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

# We don't want to install 3rd party modules on a target machine, too noisy.
def prompt(*args)
    print(*args)
    gets
end

# Return applications in the given path.
def get_files(path) 
  applications = Dir.entries(path)
  applications.each do |i|
    i.slice! '.app'
    puts i
  end
end

# Let's generate some fucking osascript.
def generate_osascript()
  app = prompt 'pick applicaton: '
  app_name = app.chomp

  want_message = prompt 'Do you want to enter a custom message (y/n)? '
  me_want_message = want_message.chomp

  if me_want_message.eql? 'y'
    message = prompt 'pick custom message: '
    custom_message = message.chomp
    pbcopy("osascript -e \'tell app \"#{app_name}\" to activate\' -e \'tell app \"#{app_name}\" to activate\' -e \'tell app \"#{app_name}\" to display dialog \"#{app_name} #{custom_message}\" & return & return  default answer \"\" with icon 1 with hidden answer with title \"#{app_name}\"\'")
  elsif me_want_message.eql? 'n'
    custom_message = "requires that you type your password to apply changes."
    pbcopy("osascript -e \'tell app \"#{app_name}\" to activate\' -e \'tell app \"#{app_name}\" to activate\' -e \'tell app \"#{app_name}\" to display dialog \"#{app_name} #{custom_message}\" & return & return  default answer \"\" with icon 1 with hidden answer with title \"#{app_name}\"\'")
  else
    puts "U DUN GOOF'd"
  end
end

get_files(path)
generate_osascript()