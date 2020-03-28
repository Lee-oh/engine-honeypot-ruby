require 'mongoid'
require "../../lib/models/event.rb"
if Event.create_indexes
    puts "Create Table Intrusion..."
else
    puts "Not Create Table Intrusion..."
end