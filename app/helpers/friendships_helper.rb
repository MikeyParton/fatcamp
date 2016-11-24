module FriendshipsHelper

	def friend_from_friendship(fs)
		(current_user.id == fs.sender_id) ? User.find(fs.receiver_id).name : User.find(fs.sender_id).name
	end

end