module Notification
    class Mqtt
        def initialize
            @connect = MQTT::Client.connect(
            :host => 'soldier.cloudmqtt.com',
            :username => 'ygnedmrn',
            :password => 'eTyYSUQy43Hb',
            :port => '15639')
        end
        def send_mqtt(ip,port,geolocation)
        @connect.publish('honeypot', "#{ip} - #{port} - #{geolocation} - #{Time.now}",0,1)
        end
    end
end