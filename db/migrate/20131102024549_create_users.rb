class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :email
      t.string :image
      t.text :token
      t.text :refresh_token
      t.integer :expires_at
      t.boolean :expires

      t.timestamps
    end
    add_index :users, :uid, unique: true
    add_index :users, :email, unique: true
  end
end
