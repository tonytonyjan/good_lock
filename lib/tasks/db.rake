namespace :db do
  desc "清理資料庫"
  task clear: :environment do
    Event.destroy_all
    NewsItem.destroy_all
  end
end
