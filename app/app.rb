require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb', layout: 'layouts/layout'
  plugin :assets, css: 'app.css', path: 'app/assets'
  plugin :public, root: 'public'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash
  plugin :multi_route

  include AuthHelper

  def session
    env['rack.session']
  end

  def cookies
    request.cookies
  end

  def csrf_token
    env['rack.csrf.token']
  end

  def csrf_tag
    "<input type='hidden' name='_csrf' value='#{csrf_token}' />"
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

    response.status = 404
    view('pages/not_found')
  end
end

require_relative 'routes/auth'
