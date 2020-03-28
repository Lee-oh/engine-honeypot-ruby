port_1 = ARGV[0]
port_2 = ARGV[1]
port_3 = ARGV[2]
threads = []
if port_1
    threads << Thread.new {system("start main.rb #{port_1}")}    
end
if port_2
    threads << Thread.new {system("start main.rb #{port_2}")} 
end
if port_3
    threads << Thread.new {system("start main.rb #{port_3}")} 
end
threads.each { |thr| thr.join }
