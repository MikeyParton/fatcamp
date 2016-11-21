module ApplicationHelper

	def min_length
		if @minimum_password_length
			"(#{@minimum_password_length} characters minimum)"
		end
	end
	
end
