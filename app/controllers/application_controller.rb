class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_login!
    respond_to do |format|
      format.html { redirect_to new_session_path }
      format.json { head :unauthorized }
    end
  end

  def token_expired?
    current_user && Time.now.to_i > current_user.expires_at
  end

  def refresh_token
    redirect_to '/auth/google_oauth2'
  end
end