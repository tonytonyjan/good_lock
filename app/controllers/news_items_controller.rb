class NewsItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :require_login!, unless: :current_user
  before_action :set_news_item, only: %i(show)
  authorize_resource

  def index
    begin
      @news_items = NewsItem.search(params).page params[:page]
    rescue ArgumentError
      head :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  def news_item_params
    params[:news_item]
  end
end
