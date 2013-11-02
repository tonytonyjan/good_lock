class NewsItem < ActiveRecord::Base
  serialize :raw_data

  validates :guid, uniqueness: true
  validates :title, :description, :link, :publish_at, :raw_data, presence: true

  def self.new_from_feed_item item
    new guid: item['guid']['content'],
        title: item['title'],
        description: item['description'],
        link: item['link'],
        publish_at: item['pubDate'],
        raw_data: item
  end

  def self.search params
    if params[:begin_at].present? && params[:end_at].present?
      begin_at, end_at = Time.parse(params[:begin_at]), Time.parse(params[:end_at])
      self.where(publish_at: begin_at..end_at)
    else
      self
    end
  end
end
