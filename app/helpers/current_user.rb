module CurrentUser
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = load_user_from_session
  rescue StandardError => e
    AppLogger.warn "Session error (clearing session): #{e.message}"
    session.clear
    @current_user = nil
  end

  private

  def load_user_from_session
    return nil unless session[:user_id]

    User.find_by(id: session[:user_id])
  end
end
