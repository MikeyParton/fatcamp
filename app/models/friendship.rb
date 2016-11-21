class Friendship < ApplicationRecord

	after_initialize :init
	belongs_to :sender, class_name: "User"
	belongs_to :receiver, class_name: "User"

	enum status: [:pending, :approved]

	def init
		self.status ||= :pending
	end

end