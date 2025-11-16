class App < Roda
  route 'auth' do |r|
    r.get 'login' do
      r.redirect '/' if current_user
      view('auth/login')
    end

    r.post 'login' do
      check_csrf_with_logging(r, 'login')
      handle_login(r)
    end

    r.get 'register' do
      r.redirect '/' if current_user
      view('auth/register')
    end

    r.post 'register' do
      check_csrf_with_logging(r, 'registration')
      handle_register(r)
    end

    r.get 'logout' do
      handle_logout(r)
    end
  end

  def handle_login(req)
    result = AuthService.authenticate(req.params['email'], req.params['password'])

    unless result[:success]
      AppLogger.warn "Login failed for #{req.params['email']}: #{result[:error]}"
      flash[:error] = 'Invalid email or password'
      return req.redirect '/auth/login'
    end

    create_user_session(result[:user])
    flash[:success] = 'Successfully logged in'
    req.redirect '/'
  end

  def handle_register(req)
    result = AuthService.register(
      req.params['email'],
      req.params['password'],
      req.params['password_confirmation']
    )

    unless result[:success]
      flash[:error] = result[:errors].join(', ')
      return req.redirect '/auth/register'
    end

    create_user_session(result[:user])
    flash[:success] = 'Successfully registered'
    req.redirect '/'
  end

  def handle_logout(req)
    session.clear
    flash[:success] = 'Successfully logged out'
    req.redirect '/'
  end

  private

  def create_user_session(user)
    session[:user_id] = user.id
    session[:expires_at] = 14.days.from_now.to_i
  end

  def check_csrf_with_logging(req, action)
    check_csrf!
  rescue StandardError => e
    email = req.params['email']&.to_s || 'unknown'
    AppLogger.warn "CSRF check failed on #{action} for #{email}: #{e.message}"
    raise
  end
end
