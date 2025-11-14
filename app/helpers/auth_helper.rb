module AuthHelper
  def current_user
    return @current_user if defined?(@current_user)

    begin
      if session[:user_id]
        if session[:expires_at] && Time.now.to_i > session[:expires_at]
          AppLogger.info "Session expired for user #{session[:user_id]}"
          session.clear
          @current_user = nil
        else
          @current_user = User.find_by(id: session[:user_id])
        end
      end
    rescue TypeError, StandardError => e
      AppLogger.warn "Session error (clearing session): #{e.message}"
      session.clear
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    return if logged_in?

    flash[:error] = 'You must be logged in to access this page'
    request.redirect '/auth/login'
  end
end
