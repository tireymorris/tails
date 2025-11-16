require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb', layout: 'layouts/layout'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash
  plugin :multi_route
  plugin :route_csrf

  include CurrentUser

  route do |r|
    @current_user = current_user

    r.multi_route

    r.root do
      if @current_user
        view('pages/dashboard')
      else
        view('pages/landing_page')
      end
    end

    AppLogger.info "404 Not Found: #{r.request_method} #{r.path}"
    response.status = 404
    view('pages/not_found')
  end
end

require_relative 'routes/auth'
require_relative 'routes/styles'
