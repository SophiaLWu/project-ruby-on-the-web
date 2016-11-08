require "socket"
require "json"

puts "What type of request would you like to make? (GET/POST)"
print ">> "
type = gets.chomp.upcase

if type == "GET"
  request = "GET /index.html HTTP/1.0\r\n" +
            "From: someuser@jmarshall.com\r\n" + 
            "User-Agent: HTTPTool/1.0\r\n"
            "\r\n"
else
  puts "Please enter the Viking's name."
  print ">> "
  viking_name = gets.chomp
  puts "Please enter the Viking's email."
  print ">> "
  viking_email = gets.chomp
  viking = {:viking => {:name => viking_name, :email => viking_email}}.to_json
  request = "POST /thanks.html HTTP/1.0\r\n" +
            "From: somerando@random.com\r\n" +
            "User-Agent: HTTPTool/1.0\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: #{viking.length}\r\n" +
            "\r\n#{viking}"
end

socket = TCPSocket.open("localhost", 3000)
socket.print(request)
response = socket.read
puts response