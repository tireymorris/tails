# frozen_string_literal: true

require_relative 'config/environment'
require 'rack/attack'
require 'roda/session_middleware'

use Rack::Attack

App.use(RodaSessionMiddleware, SESSION_OPTIONS)

run App.freeze.app
