class MenuItemsController < ApplicationController
	#respond_to :html, :xml, :json

	def index
		respond_to do |format|
			format.html
			format.json { render json: MenuItemsDatatable.new(view_context) }
		end
	end

	def menu_items_for_menu
		user_order = UserOrder.find(params[:id])
		respond_to do |format|
			format.html
			format.json { render json: MenuItemsDatatable.new(view_context, user_order) }
		end
	end
end
