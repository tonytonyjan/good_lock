class AddImageUrlToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :image_url, :text
  end
end
