class MasterOrderController < ApplicationController

	def choose_menu
		render 'master_order/choose_menu', :layout => 'home'
	end

	def create
		if params[:menu] && !params[:menu].empty?
			mo = MasterOrder.create ({ menu_id: params[:menu], user_id: current_user.id, deadline_crossed: false, date_of_order: DateTime.now })
			@user_order = UserOrder.create ({user_id: current_user.id, master_order_id: mo.id, paid: false})
			flash[:notice] = 'Erfolgreich eine Masterorder erstellt'
		else
			flash[:error] = 'Bitte eine Karte aussuchen!'
		end
		redirect_to user_order_path(@user_order)
	end
end
