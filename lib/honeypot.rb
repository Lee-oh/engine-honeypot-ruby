module Honeypot
    class Spec
        def initialize
        end
        def honeyconfig(port,reader,mqtt)
            begin
                tcpserver = TCPServer.new("", port)
                if tcpserver
                    puts "Honeypot Activated!"
                    loop do
                        socket = tcpserver.accept
                        sleep(1)
                        if socket
                            Thread.new do
                                response = "Access denied!"
                                remotePort, remoteIp = Socket.unpack_sockaddr_in(socket.getpeername)
                                puts ""
                                puts "  Intrusion attempp detected! from #{remoteIp}:#{remotePort} (#{Time.now.to_s})"
                                puts " -----------------------------"
                                reciv = socket.recv(1024)
                                counter = 0
                                log_array = Array.new
                                reciv.split(/\r\n/).each do |i|
                                    puts "#{counter} - #{i.to_s.split(':').drop(0)}"
                                    log_array.push(i.to_s.split(':').drop(0))
                                    counter+=1
                                end
                                record = reader.get(remoteIp)
                                if record.nil?
                                    puts "#{remoteIp} was not found in the database"
                                    geolocation = "Geolocation not found"
                                else
                                    geolocation = record['city']['names']['en']
                                end
                                event_json = {
                                "host": "#{remoteIp}",
                                "port": "#{remotePort}",
                                "logs": log_array,
                                "geolocation": "#{geolocation}"
                                }
                                puts event_json
                                event_log = Event.create(event_json)
                                mqtt.send_mqtt(remoteIp,remotePort,geolocation)
                                if event_log.save
                                    puts "Log Save"
                                else
                                   puts "Log Unsaved"
                                end
                                sleep(2)
                                socket.write("HTTP/1.1 200 OK\r\n" +
                                "Content-Type: text/plain\r\n" +
                                "Content-Length: #{response.bytesize}\r\n" +
                                "Connection: close\r\n" +"\r\n" + response)
                                socket.close
                            end
                        end
                    end
                end
            rescue Errno::EACCES
                puts ""
                puts " Error: Honeypot requires root privileges."
                puts ""
            rescue Errno::EADDRINUSE
                puts ""
                puts " Error: Port in use."
                puts ""
            rescue
                puts ""
                puts " Unknown error."
                puts ""
            end
        end
    end
end