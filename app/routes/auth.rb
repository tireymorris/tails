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

      if user
        auth_result = user.authenticate(password)
        AppLogger.debug "Authentication result: #{auth_result ? 'success' : 'failed'}"

        if auth_result
          session[:user_id] = user.id
          session[:expires_at] = 24.hours.from_now.to_i
          AppLogger.info "User #{user.id} (#{email}) logged in successfully"
          flash[:success] = 'Successfully logged in'
          r.redirect '/'
        else
          AppLogger.warn "Failed login attempt for #{email}: incorrect password"
          flash[:error] = 'Invalid email or password'
          r.redirect '/auth/login'
        end
      else
        AppLogger.warn "Failed login attempt: no user found with email #{email}"
        flash[:error] = 'Invalid email or password'
        r.redirect '/auth/login'
      end
    end

    r.get 'register' do
      view('auth/register')
    end

    r.post 'register' do
      email = r.params['email']
      AppLogger.info "=== REGISTRATION START for #{email} ==="
      AppLogger.debug "Password present: #{r.params['password'].present?}, Confirmation present: #{r.params['password_confirmation'].present?}"
      AppLogger.debug "Passwords match: #{r.params['password'] == r.params['password_confirmation']}"

      user = User.new(
        email: email,
        password: r.params['password'],
        password_confirmation: r.params['password_confirmation']
      )

      AppLogger.debug "User valid: #{user.valid?}"
      AppLogger.debug "User errors: #{user.errors.full_messages.join(', ')}" unless user.valid?

      if user.save
        AppLogger.info "User #{user.id} (#{email}) registered successfully"
        AppLogger.debug "Password digest created: #{user.password_digest.present?}"
        session[:user_id] = user.id
        session[:expires_at] = 24.hours.from_now.to_i
        flash[:success] = 'Successfully registered'
        AppLogger.info '=== REGISTRATION SUCCESS - redirecting to / ==='
        r.redirect '/'
      else
        AppLogger.warn "Registration failed for #{email}: #{user.errors.full_messages.join(', ')}"
        flash[:error] = user.errors.full_messages.join(', ')
        AppLogger.info '=== REGISTRATION FAILED - redirecting to /auth/register ==='
        r.redirect '/auth/register'
      end
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
end
