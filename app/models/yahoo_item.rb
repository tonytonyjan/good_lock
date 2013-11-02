# == Schema Information
#
# Table name: news_items
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  link        :string(255)
#  publish_at  :datetime
#  raw_data    :text
#  created_at  :datetime
#  updated_at  :datetime
#  image_url   :text
#  type        :string(255)
#

class YahooItem < NewsItem
  def self.new_from_feed_item item
    new_record = new title: item['title'],
        description: item['description'],
        link: item['link'],
        publish_at: item['pubDate'],
        raw_data: item
    new_record.image_url = item['content'].try(:[], 'url') if item['content'].try(:[], 'type').try(:start_with?, 'image')
    new_record
  end

  def reload_from_raw_data!
    news_item = NewsItem.new_from_feed_item raw_data
    update news_item.attributes.except('id', 'created_at', 'updated_at')
  end
end
