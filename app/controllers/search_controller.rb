class SearchController < ApplicationController

	def index
	  if params[:q].nil?
	    @articles = User.all
	  else
	    @articles = User.search(params[:q])
	  end
	end

end
