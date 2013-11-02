json.array!(@news_items) do |news_item|
  json.extract! news_item, :id, :guid, :title, :description, :link, :publish_at, :raw_data
  json.url news_item_url(news_item, format: :json)
end
