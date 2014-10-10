require 'socket'                                            # Get sockets from stdlib
require 'thread'

class Server                                                
  attr_accessor :socket, :IsOpen                            #socket is the socket connection for each server, 
  def initialize()                  #Isopen is a boolean for if the socket is still open or not
   @socket = TCPServer.open(PortNumber)
   @IsOpen = true
  end
end


PortNumber = ARGV[0]

IPAddress = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]

server1 = Server.new()      #create new server

q = Queue.new


workers = (0...4).map do # make 4 threads
  Thread.new do
    begin   
      while server1.IsOpen == true 
       if q.length > 0
          client = q.pop      # get the socket from the queue       
          line = client.gets # Read lines from the socket
          puts line                                             # And print with platform line terminator  
          headers,body = line.split                             # Split response at first blank line into headers and body
                                    
          if line == "KILL_SERVICE\n"
             client.puts "Closing the connection. Server is closing"
              server1.IsOpen = false                                    # the socket is no longer open
          elsif headers == "HELLO"
              client.puts "HELLO #{body}\nIP:#{IPAddress}\nPort:#{PortNumber}\nStudentID:10327713"
          else
              client.puts "Closing the connection."             #do whatever normally...
          end
          client.close# Disconnect from the client
         end                                        
     end
    rescue ThreadError
    end
  end
end; 

while server1.IsOpen == true                               #while socket is open                                             
  q.push(server1.socket.accept)  #take in new clients and push into queue
end
workers.map(&:join);    #stop all threads when they have finished running
server1.socket.close  #close the socket
puts"Server Closed"                                        #when socket is closed





