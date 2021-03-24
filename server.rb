require 'socket'
require 'jwt'
require 'active_support/all'
$no_of_client = 0
class Server
   def encode(payload, expiration)
      $no_of_client += 1
      payload[:exp] = expiration
      JWT.encode(payload, 'SECRET')
   end

   def decode(token)
      return JWT.decode(token, 'SECRET')[0]
   rescue
      $no_of_client -= 1
      puts "Your Token Expired"
     false
   end
   def initialize(socket_address, socket_port)
     @server_socket = TCPServer.open(socket_port, socket_address)
     @connections_details = Hash.new
     @free_tokens = Array.new(5)
     @connections_details[:server] = @server_socket
     puts 'Started server.........'
     run
   end

   def run
      loop do
         client_connection = @server_socket.accept
      if !@connections_details[:token].present?
         token = encode(@connections_details, Time.now.to_i + 60)
         @connections_details[:token] = token
      end
         decoded_token = decode(@connections_details[:token])
         puts "#{@connections_details}"
         client_connection.close  if !decoded_token
      end
   end

end

server = Server.new( 8080, "localhost" )



   

