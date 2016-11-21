class ChangeImagePathOnPostsToImage < ActiveRecord::Migration[5.0]
  def change
  	rename_column :posts, :image_path, :image
  end
end