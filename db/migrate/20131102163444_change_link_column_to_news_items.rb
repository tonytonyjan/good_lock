class ChangeLinkColumnToNewsItems < ActiveRecord::Migration
  def up
    change_column(:news_items, :link, :text, limit: nil)
  end

  def down
    change_column(:news_items, :link, :string)
  end
end
