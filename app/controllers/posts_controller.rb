class PostsController < ApplicationController
	
	def create
		@user = current_user
		@post = current_user.posts.build(post_params)
		@comment = Comment.new
		if params[:post][:image].present?
      image = convert_data_uri_to_upload({image: params[:post][:image], filename: unique_filename})
      @post.image  = image[:url_large]
    end
		@post.save
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@user = current_user
		@post = Post.find(params[:id])
		@post.destroy
		respond_to do |format|
			format.js { flash.now[:success] = "Post deleted" }
		end
	end

	private

		def post_params
			params.require(:post).permit(:text, :weight, :image)
		end

end
