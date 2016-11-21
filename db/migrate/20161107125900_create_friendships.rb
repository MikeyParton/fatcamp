class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships do |t|
			t.integer :sender_id, index: true
			t.integer :receiver_id, index: true
			t.integer :status
      t.timestamps
    end
  end
end