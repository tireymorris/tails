module AuthHelper
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = load_user_from_session
  rescue StandardError => e
    handle_session_error(e)
    @current_user = nil
  end

  def require_login
    return if current_user.present?

    AppLogger.warn "Unauthorized access attempt to #{request.path} from IP #{request.ip}"
    flash[:error] = 'You must be logged in to access this page'
    request.redirect '/auth/login'
  end

  private

  def load_user_from_session
    return nil unless session[:user_id]
    return nil if session_expired?

    User.find_by(id: session[:user_id])
  end

  def session_expired?
    return false unless session[:expires_at]

    if Time.now.to_i > session[:expires_at]
      AppLogger.info "Session expired for user #{session[:user_id]}"
      session.clear
      true
    else
      false
    end
  end

  def handle_session_error(err)
    AppLogger.warn "Session error (clearing session): #{err.message}"
    session.clear
  end
end
