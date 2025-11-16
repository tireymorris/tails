class App < Roda
  route 'auth' do |r|
    AppLogger.debug "Auth route hit: #{r.request_method} #{r.path}"

    r.get 'login' do
      r.redirect '/' if current_user
      view('auth/login')
    end

    r.post 'login' do
      begin
        check_csrf!
      rescue StandardError => e
        AppLogger.warn "CSRF check failed on login for #{r.params['email']}: #{e.message}"
        raise
      end
      handle_login(r)
    end

    r.get 'register' do
      r.redirect '/' if current_user
      view('auth/register')
    end

    r.post 'register' do
      begin
        check_csrf!
      rescue StandardError => e
        AppLogger.warn "CSRF check failed on registration for #{r.params['email']}: #{e.message}"
        raise
      end
      handle_register(r)
    end

    r.get 'logout' do
      handle_logout(r)
    end
  end

  def handle_login(req)
    result = AuthService.authenticate(req.params['email'], req.params['password'])

    if result[:success]
      create_user_session(result[:user])
      flash[:success] = 'Successfully logged in'
      AppLogger.debug "Login success - Session keys: #{session.keys.inspect}"
      req.redirect '/'
    else
      AppLogger.warn "Login failed for #{req.params['email']}: #{result[:error]}"
      flash[:error] = 'Invalid email or password'
      req.redirect '/auth/login'
    end
  end

  def handle_register(req)
    result = AuthService.register(
      req.params['email'],
      req.params['password'],
      req.params['password_confirmation']
    )

    if result[:success]
      handle_register_success(result, req)
    else
      handle_register_failure(result, req)
    end
  end

  def handle_register_success(result, req)
    create_user_session(result[:user])
    AppLogger.info "User #{result[:user].id} session created after registration"
    flash[:success] = 'Successfully registered'
    req.redirect '/'
  end

  def handle_register_failure(result, req)
    AppLogger.debug "Registration failed in route handler: #{result[:errors].join(', ')}"
    flash[:error] = result[:errors].join(', ')
    req.redirect '/auth/register'
  end

  def handle_logout(req)
    user_id = session[:user_id]
    AppLogger.info "User #{user_id} logged out" if user_id
    session.clear
    flash[:success] = 'Successfully logged out'
    req.redirect '/'
  end

  def create_user_session(user)
    session[:user_id] = user.id
    session[:expires_at] = 14.days.from_now.to_i
    AppLogger.debug "Session created for user #{user.id} (#{user.email}), expires at #{Time.at(session[:expires_at])}"
  end
end
