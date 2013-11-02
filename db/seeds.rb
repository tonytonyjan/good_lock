news_seed_path = Rails.root.join('db', 'news_seed.json')
JSON.parse(IO.read(news_seed_path)).each do |news|
  news_item = NewsItem.new_from_feed_item news
  news_item.save
end if File.exist? news_seed_path