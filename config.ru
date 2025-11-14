require_relative 'config/environment'
require 'rack/session'

use Rack::Session::Cookie,
    secret: ENV['SESSION_SECRET'] || 'change_me_in_production_please_use_long_random_string_at_least_64_chars',
    key: 'tails.session',
    path: '/',
    httponly: true,
    secure: ENV['RACK_ENV'] == 'production',
    same_site: :lax,
    expire_after: 24 * 60 * 60

run App
