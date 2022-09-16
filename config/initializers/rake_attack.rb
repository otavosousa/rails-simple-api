class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # libera tudo para o localhost 
  safelist('allow-localhost') do |req|
    '0.0.0.0' == req.ip || '::1' == req.ip
  end

  #limita a 5 chamadas de 5 em 5 segundos
  throttle('req/ip', limit: 5, period: 5) do |req|
    req.ip
  end
end