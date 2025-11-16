require_relative 'config/environment'
require 'rack/session'
require 'rack/attack'
require 'rack/csrf'

use Rack::Attack

use Rack::Session::Cookie,
    secret: ENV.fetch('SESSION_SECRET'),
    key: 'tails.session',
    path: '/',
    httponly: true,
    secure: ENV['RACK_ENV'] == 'production',
    same_site: :lax,
    expire_after: 24 * 60 * 60

use Rack::CSRF, raise: true, skip: lambda { |env|
  env['rack.attack.matched']
}

run App
