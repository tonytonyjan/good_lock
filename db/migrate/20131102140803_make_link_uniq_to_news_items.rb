class MakeLinkUniqToNewsItems < ActiveRecord::Migration
  def change
    add_index :news_items, [:link, :type], unique: true
  end
end
