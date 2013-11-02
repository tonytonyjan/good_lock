news_seed_path = Rails.root.join('db', 'news_seed.json')

JSON.parse(IO.read(news_seed_path)).each do |news|
  news_item = case news['tj_type']
  when 'FlickrItem'
    FlickrItem.new_from_flickr_item news.except!('tj_type')
  when 'YahooItem'
    YahooItem.new_from_feed_item news.except!('tj_type')
  when 'ICultureItem'
    ICultureItem.new_from_item news.except!('tj_type')
  end
  news_item.save
end if File.exist? news_seed_path