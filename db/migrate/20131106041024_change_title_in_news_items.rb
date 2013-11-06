class ChangeTitleInNewsItems < ActiveRecord::Migration
  def up
    change_column :news_items, :title, :text, limit: nil
  end

  def down
    change_column :news_items, :title, :string
  end
end
