class AddLotsOfThingsToUser < ActiveRecord::Migration[5.0]
  def change
		add_column :users, :profile_pic, :string
		add_column :users, :cover_pic, :string
		add_column :users, :profile_text, :text
  end
end
