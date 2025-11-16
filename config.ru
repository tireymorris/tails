require_relative 'config/environment'
require 'rack/session'
require 'rack/attack'

use Rack::Attack

use Rack::Session::Cookie,
    secret: ENV.fetch('SESSION_SECRET'),
    key: 'tails.session',
    path: '/',
    httponly: true,
    secure: ENV['RACK_ENV'] == 'production',
    same_site: :lax,
    expire_after: 24 * 60 * 60

run App
