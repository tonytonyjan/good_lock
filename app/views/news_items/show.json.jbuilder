json.extract! @news_item, :type, :title, :description, :image_url, :link, :publish_at, :raw_data
json.stripped_title strip_tags(@news_item.title)
json.stripped_description strip_tags(@news_item.description)