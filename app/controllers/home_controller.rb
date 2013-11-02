class HomeController < ApplicationController
  before_action :require_login!, unless: :current_user
  before_action :refresh_token, if: :token_expired?

  def index
  end
end
