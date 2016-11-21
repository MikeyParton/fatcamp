class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
			t.text :text
			t.integer :user_id, index: true
			t.integer :commentable_id, index: true
			t.string :commentable_type, index: true
      t.timestamps
    end
  end
end