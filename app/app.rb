# frozen_string_literal: true

require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb', layout: 'layouts/layout'
  plugin :flash
  plugin :multi_route
  plugin :route_csrf, skip_if: -> { ENV['RACK_ENV'] == 'test' }
  plugin :sessions, secret: ENV.fetch('SESSION_SECRET', 'test_secret')

  include CurrentUser

  route do |r|
    @current_user = current_user

    r.multi_route

    r.root do
      if @current_user
        view('pages/dashboard')
      else
        r.redirect '/auth/login'
      end
    end

    AppLogger.info "404 Not Found: #{r.request_method} #{r.path}"
    response.status = 404
    view('pages/not_found')
  end
end

require_relative 'routes/auth'
