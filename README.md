# 🔌 Ruby Network Stack

A lightweight HTTP server and client built from scratch in Ruby using raw TCP sockets — no frameworks, no magic.

This project was built as a learning exercise to understand what happens under the hood when a browser makes an HTTP request, and how frameworks like Rails abstract these low-level details.

---

## 📦 What's Inside

| File | Responsibility |
|---|---|
| `http_servidor.rb` | Multi-threaded HTTP server with route registration |
| `http_cliente.rb` | HTTP client that speaks directly over TCP |
| `waf.rb` | Basic WAF (Web Application Firewall) — blocks SQLi and XSS |

---

## 🧠 Concepts Covered

- **TCP Sockets** — opening connections, sending and receiving raw bytes
- **HTTP Protocol** — manually parsing requests and building responses (status line, headers, body)
- **Object-Oriented Ruby** — classes, instance variables, private methods, blocks and Procs
- **Multithreading** — handling multiple simultaneous clients with `Thread.new`
- **Web Security** — detecting SQL Injection and XSS attacks via URL pattern matching and decoding

---

## 🚀 Running the Server

**Requirements:** Ruby 3.x

```bash
# Clone the repo
git clone https://github.com/your-username/network_stack
cd network_stack

# Start the server
ruby http_servidor.rb
```

Server will be available at `http://localhost:4000`

---

## 🛣️ Available Routes

| Method | Path | Response |
|---|---|---|
| GET | `/` | Hello World page |
| GET | `/sobre` | About page |
| any | unknown path | 404 Not Found |
| any | malicious path | 400 Bad Request (WAF) |

---

## 🔒 WAF — Security Layer

The `WAF` class intercepts requests before any routing occurs and blocks common attack patterns:

```
GET /?id=' OR 1=1     → 400 Bad Request  (SQL Injection)
GET /%3Cscript%3E     → 400 Bad Request  (XSS — URL encoded)
GET /<script>         → 400 Bad Request  (XSS — raw)
```

Detections:
- URL-decodes the path before analysis (catches encoded attacks)
- Case-insensitive matching
- Flexible whitespace matching (`OR  1=1`, `OR 1=1`, etc.)

---

## 🧵 Multithreading

Each incoming connection is handled in its own thread, allowing the server to process multiple requests simultaneously:

```ruby
loop do
  client = server.accept
  Thread.new do
    handle_request(client)
  end
end
```

---

## 🔧 Using the HTTP Client

```ruby
require_relative 'http_cliente'

client = HTTPClient.new("example.com")
response = client.get("/")

puts response[:status]   # "HTTP/1.1 200 OK"
puts response[:body]     # HTML content
```

---

## 📐 Architecture

```
Browser / curl
     │
     │ TCP connect (port 4000)
     ▼
┌─────────────────────┐
│     HTTPServer      │  ← accepts connections, manages threads
├─────────────────────┤
│        WAF          │  ← inspects path, blocks attacks
├─────────────────────┤
│    Route Handler    │  ← matches path to registered block
├─────────────────────┤
│   send_response     │  ← builds and sends HTTP response
└─────────────────────┘
```

---

## 📚 Motivation

Most developers use Rails or Sinatra without knowing what's happening at the TCP level. This project strips away the abstractions to show that HTTP is just **formatted text over a socket** — and that a functional web server can be built in under 80 lines of Ruby.
