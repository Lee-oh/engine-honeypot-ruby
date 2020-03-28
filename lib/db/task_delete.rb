require 'mongoid'
require "../../lib/models/event.rb"
Mongoid.load!("../../lib/config/mongoid.yml", :development)
if Event.all.destroy
    puts "Delete Table Intrusion..."
else
    puts "Not Deeleted Table Intrusion..."
end