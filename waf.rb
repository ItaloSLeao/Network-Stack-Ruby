require 'uri'

class WAF

  def request_maliciosa?(path)
    decode = URI.decode_www_form_component(path)
    decode.match?(/script|OR\s+1=1/i)
  end

end