namespace :news do
  desc "撈所有 Yahoo、Flickr 的資料"
  task fetch: %i(fetch:yahoo fetch:flickr fetch:iculture)

  desc "先從 news_seed.json 匯入新聞到 db，再 `news:fetch`，再將 db 匯出回 news_seed.json"
  task export: :environment do
    File.write(Rails.root.join('db', 'news_seed.json'), NewsItem.all.map{ |x| x.raw_data.merge tj_type: x.type }.to_json)
  end

  desc "從 raw data 重新產生資料"
  task reload: :environment do
    NewsItem.find_each{ |news_item| news_item.reload_from_raw_data! }
  end

  namespace :fetch do
    desc "透過 YQL 撈新聞 RSS feed"
    task yahoo: :environment do
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
              news_item = YahooItem.new_from_feed_item(item)
              if news_item.save
                logger.info %Q{\e[1;32m[新增]\e[0;39;49m #{I18n.l news_item.publish_at, format: :long} "#{news_item.title}"}
              else
                logger.warn %Q{\e[1;31m[跳過]\e[0;39;49m #{I18n.l news_item.publish_at, format: :long} #{news_item.errors.full_messages.join(', ')}}
              end
            end
          end
        rescue Exception => e
          logger.warn "#{e.class}: #{e.message}"
          logger.warn e.backtrace.join($/)
        end
      end
    end # yahoo: :environment

    desc "抓一個禮拜內 flickr 的資料，過濾掉介紹小於十個字的照片"
    task flickr: :environment do
      uri = URI('http://api.flickr.com/services/rest')
      params = {
        method: 'flickr.photos.search',
        api_key: Settings.flickr.key,
        min_upload_date: Time.now.ago(1.week),
        extras: 'description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_l',
        tags: 'yahoo',
        # tag_mode: 'all', # (any|all)
        format: :json,
        nojsoncallback: true,
        per_page: 500
      }

      log_file = File.open(Rails.root.join('log', "#{Rails.env}.news.log"), 'a')
      logger = Logger.new MultiDelegator.delegate(:write, :close).to(STDOUT, log_file)

      uri.query = URI.encode_www_form(params)

      logger.info "[請求] #{uri}"

      begin
        res = Net::HTTP.get_response(uri)
        if res.is_a?(Net::HTTPSuccess)
          body = JSON.parse(res.body)
          body['photos']['photo'].to_a.each do |item|
            flickr_item = FlickrItem.new_from_flickr_item(item)
            if flickr_item.save
              logger.info %Q{\e[1;32m[新增]\e[0;39;49m #{I18n.l flickr_item.publish_at, format: :long} "#{flickr_item.title}"}
            else
              logger.warn %Q{\e[1;31m[跳過]\e[0;39;49m #{I18n.l flickr_item.publish_at, format: :long} #{flickr_item.errors.full_messages.join(', ')}}
            end
          end
        end
      rescue Exception => e
        logger.warn "#{e.class}: #{e.message}"
        logger.warn e.backtrace.join($/)
      end
    end # task flickr: :environment do

    desc "抓取文化部的 open data"
    task iculture: :environment do
      uri = URI('http://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&keyword=2013')
      log_file = File.open(Rails.root.join('log', "#{Rails.env}.news.log"), 'a')
      logger = Logger.new MultiDelegator.delegate(:write, :close).to(STDOUT, log_file)

      logger.info "[請求] #{uri}"

      begin
        body = JSON.parse Net::HTTP.get(uri)
        body.each do |raw_item|
          ICultureItem.extract_item(raw_item).each do |item|
            i_culture_item = ICultureItem.new_from_item(item)
            if i_culture_item.save
              logger.info %Q{\e[1;32m[新增]\e[0;39;49m #{I18n.l i_culture_item.publish_at, format: :long} "#{i_culture_item.title}"}
            else
              logger.warn %Q{\e[1;31m[跳過]\e[0;39;49m #{I18n.l i_culture_item.publish_at, format: :long} #{i_culture_item.errors.full_messages.join(', ')}}
            end
          end
        end
      rescue Exception => e
        logger.warn "#{e.class}: #{e.message}"
        logger.warn e.backtrace.join($/)
      end
    end
  end
end
