class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, null: false
      t.string :event_id, index: true, null: false
      t.string :state, null: false, default: :unset

      t.timestamps
    end
    add_index :events, [:event_id, :user_id], unique: true
  end
end
