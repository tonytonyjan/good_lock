class RemoveIndexGuidFromNewsItems < ActiveRecord::Migration
  def up
    remove_index :news_items, :guid
  end

  def down
    add_index :news_items, :guid, unique: true
  end
end
