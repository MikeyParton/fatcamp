class FriendshipsController < ApplicationController
	
	def create
		@friendship = Friendship.new(friendship_params)
		@friendship.sender_id = current_user.id
		@friendship.save
		@user = params[:friendship][:page] == current_user.id ? current_user : User.find(params[:friendship][:page])
		@friend_suggestions = @user.not_friends.limit(5)
		@new_friendship = Friendship.new()
		@old_friendship = Friendship.between(current_user.id, @user.id).first
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@friendship = Friendship.find(params[:id])
		@friendship.delete
		@user = (params[:friendship][:page] == current_user.id) ? current_user : User.find(params[:friendship][:page])
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