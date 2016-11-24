class UsersController < ApplicationController

	before_action :require_login 
	before_action :reset_second_auth, only: [:home]

	def index
		ignore_empty_params()
	  @users = params.empty? ? User.all : User.search(params)
	end

	def home
		@user = current_user
		@posts = @user.feed.order(id: :desc)
		@friend_suggestions = @user.not_friends.limit(5)
		@new_friendship = Friendship.new()
		@post = Post.new
		@comment = Comment.new
		render 'show'
	end

	def show
		@user = User.find(params[:id])
		if @user.id == current_user.id
			redirect_to root_path
		else
			@comment = Comment.new
			@posts = @user.posts.order("id desc")
			@friendship = Friendship.new
		end
	end

	def update
		@user = User.find(current_user.id)
		@user.assign_attributes(user_params)
		@user.skip_confirmation!

		#update profile pic
		if params[:user][:profile_pic].present?
      new_avatar = convert_data_uri_to_upload({image: params[:user][:profile_pic], filename: unique_filename})
      @user.profile_pic  = new_avatar[:url_large]
    end

    #update cover pic
    if params[:user][:cover_pic].present?
      new_cover = convert_data_uri_to_upload({image: params[:user][:cover_pic], filename: unique_filename})
      @user.cover_pic  = new_cover[:url_large]
    end

		if @user.save
			bypass_sign_in(@user)
		end

		respond_to do |format|
    	format.js
    end
	end

	def edit_account
		@user = current_user
		if @user.valid_password?(params[:user][:password])
			session[:second_auth] = true
		end
		respond_to do |format|
			format.js
		end	
	end

	def profile
		@user = current_user
	end
	
	private

		def user_params
			params.require(:user).permit(:name, :profile_text, :email, :password, :password_confirmation, :profile_pic, :cover_pic)
		end

		def require_login
			if !user_signed_in?
				redirect_to new_user_session_path
			end
		end

		def reset_second_auth
			session[:second_auth] = nil
		end

		private

			def ignore_empty_params
				params.keys.each do |k|
					params.delete(k) if params[k].blank? 
				end
			end

end