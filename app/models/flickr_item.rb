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

class FlickrItem < NewsItem
  validates :description, length: { minimum: 10 }
  def self.new_from_flickr_item item
    new title: item['description']['_content'].presence,
        description: item['description']['_content'].presence,
        link: item['url_l'],
        image_url: item['url_l'],
        publish_at: Time.at(item['dateupload'].to_i),
        raw_data: item
  end
end
