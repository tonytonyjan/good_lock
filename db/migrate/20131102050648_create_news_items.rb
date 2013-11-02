class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.string :guid
      t.string :title
      t.text :description
      t.string :link
      t.datetime :publish_at
      t.text :raw_data

      t.timestamps
    end
    add_index :news_items, :guid, unique: true
  end
end
