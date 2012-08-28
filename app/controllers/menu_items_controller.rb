class MenuItemsController < ApplicationController
	#respond_to :html, :xml, :json

	def index
	  respond_to do |format|
	    format.html
	    format.json { render json: MenuItemsDatatable.new(view_context) }
	  end
	end
end
