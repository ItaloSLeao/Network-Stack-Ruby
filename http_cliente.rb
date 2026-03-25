require 'socket'

class HTTPClient
	def initialize(host)
		@host = host
	end
	
	def get(path)
		socket = TCPSocket.new(@host, 80) #abre uma conexao tcp com servidor na porta 80

		request  = "GET #{path} HTTP/1.1\r\n"
   	request += "Host: #{@host}\r\n"
    request += "Connection: close\r\n"
    request += "\r\n"
		
		socket.print(request) #envia o texto para o servidor

		raw_response = socket.read #le tudo que o servidor responder
		socket.close #fecha a conexao tcp

		parse_response(raw_response)
	end

	private 

	def parse_response(raw)
		headers_raw, body = raw.split("\r\n\r\n", 2) #separa o header do body na linha em branco

		lines = headers_raw.lines #extrai as linhas do header em um array

		status_line = lines.first.chomp #extrai a linha 0, o status e retira o \n

		headers = {} #instancia um hash para armazenar as chaves e os valores dos headers

		lines[1..].each do |line|
			key, value = line.chomp.split(": ", 2) #chompa a linha e separa no :
			headers[key.downcase] = value if key
		end

		{status: status_line, headers: headers, body: body}
	end
end 

client = HTTPClient.new("example.com")
response = client.get("/")

puts response[:status]
puts response[:headers].inspect
puts "------------------"
puts response[:body][0..200]

