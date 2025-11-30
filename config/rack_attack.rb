require 'rack/attack'

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('login/ip', limit: 5, period: 60) do |req|
  req.ip if req.path == '/auth/login' && req.post?
end

Rack::Attack.throttle('register/ip', limit: 3, period: 300) do |req|
  req.ip if req.path == '/auth/register' && req.post?
end

Rack::Attack.throttled_responder = lambda do |req|
  [429, { 'Content-Type' => 'text/plain' }, ['Too Many Requests']]
end

Rack::Attack.blocklisted_responder = lambda do |req|
  [403, { 'Content-Type' => 'text/plain' }, ['Forbidden']]
end
