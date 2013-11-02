namespace :news do
  desc "透過 YQL 撈新聞 RSS feed"
  task fetch: :environment do
    rss_feeds = %w(
      http://tw.news.yahoo.com/rss/
      http://tw.news.yahoo.com/rss/politics
      http://tw.news.yahoo.com/rss/local
      http://tw.news.yahoo.com/rss/entertainment
      http://tw.news.yahoo.com/rss/society
      http://tw.news.yahoo.com/rss/world
    )

    log_file = File.open(Rails.root.join('log', "#{Rails.env}.news.log"), 'a')
    logger = Logger.new MultiDelegator.delegate(:write, :close).to(STDOUT, log_file)

    rss_feeds.each do |feed|
      uri = URI('http://query.yahooapis.com/v1/public/yql')
      params = {
        format: :json,
        q: "select * from feed where url='#{feed}'"
      }
      uri.query = URI.encode_www_form(params)

      logger.info "[YQＬ] #{params[:q]}"
      logger.info "[請求] #{uri}"

      begin
        res = Net::HTTP.get_response(uri)
        if res.is_a?(Net::HTTPSuccess)
          json_body = JSON.parse(res.body)
          json_body['query']['results'].try(:[], 'item').to_a.each do |item|
            news_item = NewsItem.new_from_feed_item(item)
            if news_item.save
              logger.info %Q{\e[1;32m[新增]\e[0;39;49m #{I18n.l news_item.publish_at, format: :long} "#{news_item.title}"}
            else
              logger.warn %Q{\e[1;31m[重複]\e[0;39;49m #{I18n.l news_item.publish_at, format: :long} "#{news_item.title}"}
            end
          end
        end
      rescue Exception => e
        logger.warn "#{e.class}: #{e.message}"
        logger.warn e.backtrace.join($/)
      end
    end
    logger.close
  end

  desc "先從 news_seed.json 匯入新聞到 db，再 `news:fetch`，再將 db 匯出回 news_seed.json"
  task export: %i(db:seed fetch) do
    File.write(Rails.root.join('db', 'news_seed.json'), NewsItem.all.map(&:raw_data).to_json)
  end
end
