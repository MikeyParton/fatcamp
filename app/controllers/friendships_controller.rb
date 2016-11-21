class FriendshipsController < ApplicationController
	
	def create
		@friendship = Friendship.new(friendship_params)
		if @friendship.save
			flash[:success] = "Friend request sent"
			redirect_to root_path
		else
			redirect_to root_path
		end
	end

	private

		def friendship_params
			params.require(:friendship).permit(:sender_id, :receiver_id)
		end

end
