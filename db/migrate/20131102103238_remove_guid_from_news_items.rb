class RemoveGuidFromNewsItems < ActiveRecord::Migration
  def change
    remove_column :news_items, :guid, :text
  end
end
