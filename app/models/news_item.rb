# == Schema Information
#
# Table name: news_items
#
#  id          :integer          not null, primary key
#  guid        :text
#  title       :string(255)
#  description :text
#  link        :string(255)
#  publish_at  :datetime
#  raw_data    :text
#  created_at  :datetime
#  updated_at  :datetime
#

class NewsItem < ActiveRecord::Base
  serialize :raw_data

  validates :guid, uniqueness: true
  validates :title, :description, :link, :publish_at, :raw_data, presence: true

  def self.new_from_feed_item item
    new_record = new guid: item['guid']['content'],
        title: item['title'],
        description: item['description'],
        link: item['link'],
        publish_at: item['pubDate'],
        raw_data: item
    new_record.image_url = item['content'].try(:[], 'url') if item['content'].try(:[], 'type').try(:start_with?, 'image')
    new_record
  end

  def self.search params
    if params[:begin_at].present? && params[:end_at].present?
      begin_at, end_at = Time.parse(params[:begin_at]), Time.parse(params[:end_at])
      self.where(publish_at: begin_at..end_at)
    else
      self
    end
  end

  def reload_from_raw_data!
    news_item = NewsItem.new_from_feed_item raw_data
    update news_item.attributes.except('id', 'created_at', 'updated_at')
  end
end
