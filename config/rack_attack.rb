require 'rack/attack'

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('login/ip', limit: 5, period: 60) do |req|
  req.ip if req.path == '/auth/login' && req.post?
end

Rack::Attack.throttle('register/ip', limit: 3, period: 300) do |req|
  req.ip if req.path == '/auth/register' && req.post?
end

Rack::Attack.throttled_responder = lambda do |request|
  match_data = request.env['rack.attack.match_data']
  retry_after = match_data ? match_data[:period] : 60

  [
    429,
    {
      'Content-Type' => 'text/html',
      'Retry-After' => retry_after.to_s
    },
    ['<html><body><h1>Too Many Requests</h1><p>You have been rate limited. Please try again in ' + retry_after.to_s + ' seconds.</p></body></html>']
  ]
end

Rack::Attack.blocklisted_responder = lambda do |_request|
  [
    403,
    { 'Content-Type' => 'text/html' },
    ['<html><body><h1>Forbidden</h1><p>Your request has been blocked.</p></body></html>']
  ]
end
