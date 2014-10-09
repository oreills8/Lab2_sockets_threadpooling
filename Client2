require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2500

s = TCPSocket.open(hostname, port)


#while line = s.gets   # Read lines from the socket

#puts line.chop      # And print with platform line terminator
#end
s.puts "HELLO test\n"

while line = s.gets   # Read lines from the socket
  print line
end
s.close               # Close the socket when done
