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

class ICultureItem < NewsItem

  def self.extract_item item
    item['showInfo'].map do |info|
      {
        title: item['title'].presence,
        description: item['descriptionFilterHtml'].presence,
        link: item['sourceWebPromote'].presence,
        image_url: item['imageUrl'].presence,
        publish_at: Time.parse(info['time'])
      }
    end
  end

  def self.new_from_item item
    item.to_options!
    new title: item[:title].presence,
        description: item[:description].presence,
        link: item[:link].presence,
        image_url: item[:image_url].presence,
        publish_at: item[:publish_at],
        raw_data: item
  end
end
