class AddTypeToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :type, :string
  end
end
