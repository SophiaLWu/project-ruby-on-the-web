require "socket"
require "json"

class Server

  def initialize
    @server = TCPServer.open(3000)
  end

  def run_server
    loop do
      @client = @server.accept
      request, sender = @client.recvfrom(1000)
      header, body = request.split("\r\n\r\n", 2)
      split_header = header.split
      @request_type = split_header[0]
      @request_path = split_header[1][1..-1]
      @request_version = split_header[2]

      if File.exists?(@request_path)
        @response = "#{@request_version} "
        if @request_type == "GET"
          gets_request
        elsif @request_type == "POST"
          post_request(body)
        else 
          @response << "405 Method Not Allowed\r\n"
        end
      else
        @response << "404 Not Found\r\n"
      end
      @client.print(@response)
      @client.close
    end
  end

  def gets_request
    body = File.read(@request_path)
    @response << "200 OK\r\n"
    @response << "Date: #{Time.now.ctime}\r\n"
    @response << "Content-Type: text/html\r\n"
    @response << "Content-Length: #{body.length}\r\n"
    @response << "\r\n" << body
  end

  def post_request(body)
    new_text = ""
    params = JSON.parse(body)
    viking = params["viking"]
    name = viking["name"]
    email = viking["email"]
    new_text << "<li>Name: #{name}</li><li>Email: #{email}</li>"
    new_content = File.read(@request_path).gsub("<%= yield %>", new_text)
    File.open("#{name}_" + @request_path, "w") { |f| f.puts new_content }
    @response << "200 OK\r\n"
  end

end

s = Server.new
s.run_server
