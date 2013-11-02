class HomeController < ApplicationController
  before_action :require_login!, unless: :current_user
  def index
  end
end
