require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb', layout: 'layouts/layout'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash
  plugin :multi_route
  plugin :route_csrf

  include AuthHelper

  def session
    env['rack.session']
  end

  def cookies
    request.cookies
  end

  route do |r|
    @current_user = current_user

    r.multi_route

    r.root do
      AppLogger.debug "Root route hit - Session user_id: #{session[:user_id].inspect}"
      AppLogger.debug "Root route hit - @current_user: #{@current_user ? "ID #{@current_user.id} (#{@current_user.email})" : 'nil'}"
      if @current_user
        view('pages/dashboard')
      else
        view('pages/landing_page')
      end
    end

    response.status = 404
    view('pages/not_found')
  end
end

require_relative 'routes/auth'
