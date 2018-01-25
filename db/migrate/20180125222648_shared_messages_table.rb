class SharedMessagesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :shared_messages do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :receivers_id
      t.string  :message
    end
  end
end
