# Network-Stack-Ruby: Micro-WAF & HTTP Server from Scratch

Este repositório contém a implementação de um servidor HTTP desenvolvido em **Ruby**, focado no estudo de protocolos de rede e segurança defensiva. O projeto foi construído sem o uso de frameworks web (como Rails ou Sinatra), manipulando diretamente sockets TCP.

## Objetivo

O projeto demonstra a criação de um **Micro-WAF (Web Application Firewall)** capaz de interceptar, analisar e filtrar requisições maliciosas antes que estas cheguem à lógica de negócio, simulando o comportamento de firewalls corporativos.

## Funcionalidades Implementadas

- **Servidor HTTP nativo:** Manipulação de Sockets TCP e parsing manual de verbos HTTP (GET apenas), headers e body.
- **Micro-WAF:** Camada de inspeção que identifica padrões de ataques comuns como:
  - **SQL Injection:** Bloqueio de palavras-chave e carateres de escape.
  - **XSS (Cross-Site Scripting):** Filtragem de tags de script e cargas úteis maliciosas.
- **Multi-Threading:** Gerenciamento de requisições que permite o servidor atender múltiplos clientes simultaneamente (multitenancy).
- **Log estruturado:** Registro detalhado de requisições exibindo endereço IP, verbo HTTP, status e tempo da conexão.
