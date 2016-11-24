class FriendshipsController < ApplicationController
	
	def create
		@friendship = Friendship.new(friendship_params)
		@friendship.save
		@user = current_user
		@friend_suggestions = @user.not_friends.limit(5)
		@new_friendship = Friendship.new()
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@friendship = Friendship.find(params[:id])
		@friendship.delete
		@user = current_user
		@friend_suggestions = @user.not_friends.limit(5)
		@new_friendship = Friendship.new()
		respond_to do |format|
			format.js
		end
	end

	private

		def friendship_params
			params.require(:friendship).permit(:sender_id, :receiver_id)
		end

end