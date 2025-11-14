require 'roda'

class App < Roda
  plugin :render, views: 'app/views', engine: 'erb'
  plugin :assets, css: 'app.css', path: 'app/assets'
  plugin :public, root: 'public'
  plugin :sessions,
         secret: ENV['SESSION_SECRET'] || 'change_me_in_production_please_use_long_random_string_at_least_64_chars',
         key: 'ruby_app.session'
  plugin :all_verbs
  plugin :json
  plugin :halt
  plugin :flash

  include AuthHelper
  include JWTHelper

  def cookies
    request.cookies
  end

  def set_cookie_value(name, value, options = {})
    cookie_parts = ["#{name}=#{Rack::Utils.escape(value)}"]
    cookie_parts << "path=#{options[:path] || '/'}"
    cookie_parts << 'HttpOnly' if options[:httponly]
    cookie_parts << 'Secure' if options[:secure]

    existing = response['Set-Cookie']
    new_cookie = cookie_parts.join('; ')

    response['Set-Cookie'] = if existing
                               [existing, new_cookie].flatten.join("\n")
                             else
                               new_cookie
                             end
  end

  def delete_cookie_value(name)
    cookie_parts = ["#{name}=", 'path=/', 'max-age=0', 'expires=Thu, 01 Jan 1970 00:00:00 GMT']

    existing = response['Set-Cookie']
    new_cookie = cookie_parts.join('; ')

    response['Set-Cookie'] = if existing
                               [existing, new_cookie].flatten.join("\n")
                             else
                               new_cookie
                             end
  end

  route do |r|
    r.public
    r.assets

    @current_user = current_user

    r.root do
      AppLogger.debug "Root route hit - Session user_id: #{session[:user_id].inspect}"
      AppLogger.debug "Root route hit - @current_user: #{@current_user ? "ID #{@current_user.id} (#{@current_user.email})" : 'nil'}"
      AppLogger.debug "Root route hit - Cookie jwt_token present: #{cookies['jwt_token'].present?}"
      view('home')
    end

    r.on 'auth' do
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
            AppLogger.info "User #{user.id} (#{email}) logged in successfully"
            token = generate_jwt(user)
            set_cookie_value('jwt_token', token, httponly: true, secure: ENV['RACK_ENV'] == 'production')
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
          token = generate_jwt(user)
          set_cookie_value('jwt_token', token, httponly: true, secure: ENV['RACK_ENV'] == 'production')
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
        delete_cookie_value('jwt_token')
        flash[:success] = 'Successfully logged out'
        r.redirect '/'
      end
    end

    r.on 'api' do
      r.on 'protected' do
        user = verify_jwt_token(cookies['jwt_token'])

        if user
          AppLogger.debug "API request authenticated for user #{user.id}"
          r.get 'profile' do
            { user: { id: user.id, email: user.email } }
          end
        else
          AppLogger.warn 'Unauthorized API request to protected endpoint'
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
