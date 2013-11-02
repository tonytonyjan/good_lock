json.extract! @news_item, :guid, :title, :description, :image_url, :link, :publish_at, :raw_data
json.stripped_description strip_tags(@news_item.description)