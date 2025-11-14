require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb'
  plugin :assets, css: 'app.css', path: 'app/assets'
  plugin :public, root: 'public'
  plugin :cookies, secret: ENV['SESSION_SECRET'] || 'change_me_in_production_please_use_long_random_string'
  plugin :sessions, secret: ENV['SESSION_SECRET'] || 'change_me_in_production_please_use_long_random_string'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash

  include AuthHelper
  include JWTHelper

  route do |r|
    r.public
    r.assets

    @current_user = current_user

    r.root do
      view('home')
    end

    r.on 'auth' do
      r.get 'login' do
        view('auth/login')
      end

      r.post 'login' do
        email = r.params['email']
        password = r.params['password']

        user = User.authenticate(email, password)

        if user
          session[:user_id] = user.id
          token = generate_jwt(user)
          response.set_cookie('jwt_token', value: token, httponly: true, secure: ENV['RACK_ENV'] == 'production')
          flash[:success] = 'Successfully logged in'
          r.redirect '/'
        else
          flash[:error] = 'Invalid email or password'
          r.redirect '/auth/login'
        end
      end

      r.get 'register' do
        view('auth/register')
      end

      r.post 'register' do
        user = User.new(
          email: r.params['email'],
          password: r.params['password'],
          password_confirmation: r.params['password_confirmation']
        )

        if user.save
          session[:user_id] = user.id
          token = generate_jwt(user)
          response.set_cookie('jwt_token', value: token, httponly: true, secure: ENV['RACK_ENV'] == 'production')
          flash[:success] = 'Successfully registered'
          r.redirect '/'
        else
          flash[:error] = user.errors.full_messages.join(', ')
          r.redirect '/auth/register'
        end
      end

      r.get 'logout' do
        session.clear
        response.delete_cookie('jwt_token')
        flash[:success] = 'Successfully logged out'
        r.redirect '/'
      end
    end

    r.on 'api' do
      r.on 'protected' do
        user = verify_jwt_token(request.cookies['jwt_token'])

        if user
          r.get 'profile' do
            { user: { id: user.id, email: user.email } }
          end
        else
          response.status = 401
          { error: 'Unauthorized' }
        end
      end
    end

    r.on 'dashboard' do
      unless logged_in?
        flash[:error] = 'Please log in first'
        r.redirect '/auth/login'
      end

      r.get do
        view('dashboard/index')
      end
    end
  end
end
