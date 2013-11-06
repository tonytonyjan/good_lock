# == Schema Information
#
# Table name: news_items
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  link        :text
#  publish_at  :datetime
#  raw_data    :text
#  created_at  :datetime
#  updated_at  :datetime
#  image_url   :text
#  type        :string(255)
#

class NewsItem < ActiveRecord::Base
  serialize :raw_data

  validates :link, uniqueness: true
  validates :title, :description, :link, :image_url, :publish_at, :raw_data, presence: true

  default_scope -> { order(:publish_at) }

  def self.search params
    if params[:begin_at].present? && params[:end_at].present?
      begin_at, end_at = Time.parse(params[:begin_at]), Time.parse(params[:end_at])
      now = Time.now
      since = now.ago(3.days)
      if params[:fake] && begin_at.between?(since, now) && end_at.between?(since, now)
        diff = now.to_i - since.to_i
        offset = (NewsItem.count * (begin_at.to_i - since.to_i) / diff).round
        limit =  (NewsItem.count * (end_at.to_i - begin_at.to_i) / diff).round
        self.offset(offset).limit(limit)
      else
        self.where(publish_at: begin_at..end_at)
      end
    else
      self
    end
  end

  def reload_from_raw_data!
    news_item = NewsItem.new_from_feed_item raw_data
    update news_item.attributes.except('id', 'created_at', 'updated_at')
  end
end
