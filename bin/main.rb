require 'socket'
require 'mqtt'
require 'mongoid'
require 'maxmind/db'
require "../lib/honeypot.rb"
require "../lib/mqtt.rb"
require "../lib/models/event.rb"
Mongoid.load!("../lib/config/mongoid.yml", :production)
port = ARGV[0]
reader = MaxMind::DB.new('geolocation.mmdb', mode: MaxMind::DB::MODE_MEMORY)
mqtt = Notification::Mqtt.new()
Honeypot::Spec.new.honeyconfig(port,reader,mqtt)
