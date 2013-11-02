class UsersController < ApplicationController
  before_action :require_login!, unless: :current_user
  def show
    @user = current_user
    @user.refresh_token! if params[:refresh_token] == 'true'
  end
end
