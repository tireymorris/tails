require_relative 'config/environment'
require 'rack/attack'
require 'roda/session_middleware'

use Rack::Attack
use RodaSessionMiddleware,
  secret: ENV.fetch('SESSION_SECRET'),
  key: 'tails.session',
  cookie_options: {
    path: '/',
    httponly: true,
    secure: ENV['RACK_ENV'] == 'production',
    same_site: :lax
  }

run App.freeze.app
