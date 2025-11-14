require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb'
  plugin :assets, css: 'app.css', path: 'app/assets'
  plugin :public, root: 'public'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash
  plugin :multi_route

  include AuthHelper
  include CookieHelper

  def session
    env['rack.session']
  end

  def cookies
    request.cookies
  end

  route do |r|
    r.public
    r.assets

    @current_user = current_user

    r.multi_route

    r.root do
      AppLogger.debug "Root route hit - Session user_id: #{session[:user_id].inspect}"
      AppLogger.debug "Root route hit - @current_user: #{@current_user ? "ID #{@current_user.id} (#{@current_user.email})" : 'nil'}"
      view('home')
    end
  end
end

require_relative 'routes/auth'
require_relative 'routes/dashboard'
