require 'rack/attack'

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('login/ip', limit: 5, period: 60) do |req|
  req.ip if req.path == '/auth/login' && req.post?
end

Rack::Attack.throttle('register/ip', limit: 3, period: 300) do |req|
  req.ip if req.path == '/auth/register' && req.post?
end

Rack::Attack.throttle('login/email', limit: 5, period: 60) do |req|
  req.params['email'].to_s.downcase.presence if req.path == '/auth/login' && req.post?
end

Rack::Attack.throttled_responder = lambda do |env|
  retry_after = (env['rack.attack.match_data'] || {})[:period]
  [
    429,
    {
      'Content-Type' => 'text/html',
      'Retry-After' => retry_after.to_s
    },
    ['<html><body><h1>Too Many Requests</h1><p>Please try again later.</p></body></html>']
  ]
end
