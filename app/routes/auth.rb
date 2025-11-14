class App < Roda
  route 'auth' do |r|
    AppLogger.debug "Auth route hit: #{r.request_method} #{r.path}"

    r.get 'login' do
      view('auth/login')
    end

    r.post 'login' do
      email = r.params['email']
      password = r.params['password']

      AppLogger.debug "Login attempt for email: #{email}"
      user = User.find_by(email: email)
      AppLogger.debug "User found: #{user ? "ID #{user.id}" : 'nil'}"

      auth_failure("no user found with email #{email}") unless user

      auth_failure("incorrect password for #{email}") unless user.authenticate(password)

      create_user_session(user, email)
      flash[:success] = 'Successfully logged in'
      r.redirect '/'
    end

    r.get 'register' do
      view('auth/register')
    end

    r.post 'register' do
      email = r.params['email']
      AppLogger.info "Registration attempt for #{email}"

      user = build_user_from_params(r.params)
      log_validation_errors(user) unless user.valid?

      unless user.save
        AppLogger.warn "Registration failed for #{email}: #{user.errors.full_messages.join(', ')}"
        flash[:error] = user.errors.full_messages.join(', ')
        r.redirect '/auth/register'
      end

      AppLogger.info "User #{user.id} (#{email}) registered successfully"
      create_user_session(user, email)
      flash[:success] = 'Successfully registered'
      r.redirect '/'
    rescue StandardError => e
      AppLogger.error "Registration exception: #{e.class} - #{e.message}"
      AppLogger.error e.backtrace.join("\n")
      flash[:error] = "An error occurred: #{e.message}"
      r.redirect '/auth/register'
    end

    r.get 'logout' do
      user_id = session[:user_id]
      AppLogger.info "User #{user_id} logged out" if user_id
      session.clear
      flash[:success] = 'Successfully logged out'
      r.redirect '/'
    end
  end

  def auth_failure(reason)
    AppLogger.warn "Failed login attempt: #{reason}"
    flash[:error] = 'Invalid email or password'
    request.redirect '/auth/login'
  end

  def create_user_session(user, email)
    session[:user_id] = user.id
    session[:expires_at] = 24.hours.from_now.to_i
    AppLogger.info "User #{user.id} (#{email}) authenticated successfully"
  end

  def build_user_from_params(params)
    User.new(
      email: params['email'],
      password: params['password'],
      password_confirmation: params['password_confirmation']
    )
  end

  def log_validation_errors(user)
    AppLogger.debug "User validation failed: #{user.errors.full_messages.join(', ')}"
  end
end
