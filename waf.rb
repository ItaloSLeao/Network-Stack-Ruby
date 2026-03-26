require 'uri'

class WAF

  ATTACKING_PATTERNS = [
    /script/i,                    # xss — <script>
    /OR\s+1=1/i,                  # sql injection
    /UNION\s+SELECT/i,            # sql injection — extracao de dados
    /DROP\s+TABLE/i,              # sql injection — destruicao de dados
    /INSERT\s+INTO/i,             # sql injection — insercao maliciosa
    /\/(\.\.\/)+/,                      # path traversal — /../
    /<[a-z]+[^>]*>/i,             # xss — qualquer tag HTML
    /javascript:/i,               # xss — protocolo javascript
    /on\w+\s*=/i,                 # xss — event handlers (onclick=, onload=, etc)
  ]

  def malicious_request?(path)
    decode = URI.decode_www_form_component(path)

    if decode =~ /^https?:\/\// #se o caminho for uma url completa
      begin
        uri = URI.parse(decode) #extrai o caminho
        path_check = uri.path
      rescue URI::InavalidURIError
        return true #url invalida, malicioso
      end
    else
      path_check = decode
    end

    ATTACKING_PATTERNS.any? { |pattern| decode.match?(pattern) } #retorna true se algum padrao de ataque for identificado
  end

end