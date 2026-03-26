require 'uri'

class WAF

  ATTACKING_PATTERNS = [
    /script/i,                    # xss — <script>
    /OR\s+1=1/i,                  # sql injection
    /UNION\s+SELECT/i,            # sql injection — extracao de dados
    /DROP\s+TABLE/i,              # sql injection — destruicao de dados
    /INSERT\s+INTO/i,             # sql injection — insercao maliciosa
    /\/..+/,                      # path traversal — /../
    /<[a-z]+[^>]*>/i,             # xss — qualquer tag HTML
    /javascript:/i,               # xss — protocolo javascript
    /on\w+\s*=/i,                 # xss — event handlers (onclick=, onload=, etc)
  ]

  def request_maliciosa?(path)
    decode = URI.decode_www_form_component(path)
    ATTACKING_PATTERNS.any? { |pattern| decode.match?(pattern) } #retorna true se algum padrao de ataque for identificado
  end

end