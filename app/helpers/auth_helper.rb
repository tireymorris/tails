module AuthHelper
  def current_user
    return @current_user if defined?(@current_user)
    
    begin
      @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
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
    unless logged_in?
      flash[:error] = 'You must be logged in to access this page'
      request.redirect '/auth/login'
    end
  end
end

