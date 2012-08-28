class MenuItemsController < ApplicationController
	#respond_to :html, :xml, :json

	def index
		respond_to do |format|
			format.html
			format.json { render json: MenuItemsDatatable.new(view_context) }
		end
	end

	def menu_items_for_menu
		p "==============="
		p params[:id]
		p "==============="
		respond_to do |format|
			format.html
			format.json { render json: MenuItemsDatatable.new(view_context, params[:id]) }
		end
	end
end
