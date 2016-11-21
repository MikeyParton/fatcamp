class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
			t.text :text
			t.integer :user_id, index: true
			t.string :image_path
			t.decimal :weight, scale: 2, precision: 5

      t.timestamps
    end
  end
end