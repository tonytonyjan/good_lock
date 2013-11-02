class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_or_create_by_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_path, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end