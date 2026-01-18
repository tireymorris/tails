# frozen_string_literal: true

class App < Roda
  route 'auth' do |r|
    r.get 'login' do
      r.redirect '/' if current_user
      view('auth/login')
    end

    r.post 'login' do
      check_csrf! unless ENV['RACK_ENV'] == 'test'
      email = r.params['email']
      user = User.find_by(email: email)&.authenticate(r.params['password'])

      if user
        create_user_session(user)
        flash[:success] = 'Successfully logged in'
        r.redirect '/'
      else
        AppLogger.warn "Login failed for #{email}"
        flash[:error] = 'Invalid email or password'
        r.redirect '/auth/login'
      end
    end

    r.get 'register' do
      r.redirect '/' if current_user
      view('auth/register')
    end

    r.post 'register' do
      check_csrf! unless ENV['RACK_ENV'] == 'test'
      user = User.new(
        email: r.params['email'],
        password: r.params['password'],
        password_confirmation: r.params['password_confirmation']
      )

      if user.save
        create_user_session(user)
        flash[:success] = 'Successfully registered'
        r.redirect '/'
      else
        AppLogger.warn "Registration failed for #{r.params['email']}: #{user.errors.full_messages.join(', ')}"
        flash[:error] = user.errors.full_messages.join(', ')
        r.redirect '/auth/register'
      end
    end

    r.get 'logout' do
      session.clear
      flash[:success] = 'Successfully logged out'
      r.redirect '/'
    end
  end

  private

  def create_user_session(user)
    session[:user_id] = user.id
  end
end
