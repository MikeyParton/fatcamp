module PostsHelper

	def format_weight( weight, units = "lb" )
		!weight.nil? ? weight_string = "#{'%.2f' % weight}" + " #{units.pluralize(weight)}" : "----"
	end

end