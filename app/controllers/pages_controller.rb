class PagesController < ApplicationController
	
	before_action :require_login
	before_action :reset_second_auth

	def home
		@post = current_user.posts.build
		@comment = Comment.new
	end
	
	private
		def require_login
			if !user_signed_in?
				redirect_to new_user_session_path
			end
		end

		def reset_second_auth
			session[:second_auth] = nil
		end
	
end