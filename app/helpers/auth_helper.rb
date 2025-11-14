module AuthHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
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

