require 'socket'
require_relative 'waf'

class HTTPServer
  def initialize(port)
    @port = port
    @routes = {} #hash para mapear get caminho com o bloco a ser executado
    @waf = WAF.new
  end 

  def get(path, &block)
    @routes["GET #{path}"] = block #guarda o bloco no hash
  end

  def start
    server = TCPServer.new('localhost', @port) #abre a porta e escuta
    puts "Rodando em http://localhost:#{@port}"

    loop do                  #espera continuamente
      client = server.accept #bloqueia aqui ate um cliente conectar
      Thread.new do
        handle_request(client) #processa a requisicao
      end
    end
  end

  private 

  def handle_request(client)
    begin #envolve todo o metodo para evitar excecao por desconexao abrupta
      request_line = client.gets.chomp #le a requisicao
      method, path, _ = request_line.split(" ") #separa em metodo, caminho e dont care

      ip = client.peeraddr[3] #adquire o ip do cliente no array de informacoes peeraddr

      if @waf.malicious_request?(path)
        status = "400 Bad Request"
        body = "<h1>400 - Bad Request</h1>"
        send_response(client, status, body)
        log(ip, method, path, status)
        return
      end

      while !(line = client.gets.chomp).empty?
      end

      handler = @routes["#{method} #{path}"]

      if handler
        body = handler.call #executa o bloco e captura o retorno
        status = "200 OK"
      else
        body = "<h1>404 - Not Found</h1>"
        status = "404 Not Found"
      end

      send_response(client, status, body)

      log(ip, method, path, status)
    rescue => e
      puts "ERROR: #{e.message}"
    ensure
      client.close rescue nil #sempre fecha a conexao com o cliente, ainda que tenha erro
    end
  end

  def send_response(client, status, body)
    response  = "HTTP/1.1 #{status}\r\n"
    response += "Content-Type: text/html\r\n"
    response += "Content-Length: #{body.bytesize}\r\n"  # bytesize = tamanho em bytes
    response += "Connection: close\r\n"
    response += "\r\n"
    response += body

    client.print(response)
    client.close
  end

  def log(ip, method, path, status)
    puts "#{ip} - #{method} #{path} #{status} - #{Time.now}"
  end
end

app = HTTPServer.new(4000)

app.get("/") do
  "<h1>Olá, Mundo!</h1>"
end

app.get("/sobre") do
  "<h1>Sobre</h1><p>Servidor Ruby puro!</p>"
end

app.start
