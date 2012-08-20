class MasterOrdersController < ApplicationController
	respond_to :html, :xml, :json
    layout "home"

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

	def toggle_paid_of_userorder
	    # User kann nur eine MasterOrder anlegen, die deadline_crossed true hat
	    @master_order = MasterOrder.today_created_master_order_by_user_id(current_user.id)
	    @user_orders = UserOrder.find_all_by_master_order_id(@master_order)
	    userorder = @user_orders.find{|uo| uo.id == params[:user_order_id].to_i}
	    userorder.paid = !userorder.paid
	    userorder.save
	    render 'home/show_userorders_of_masterorder', :layout => 'home'
	end

	def close_master_order
		@master_order = MasterOrder.today_created_master_order_by_user_id(current_user.id)
		if !@master_order.nil?
			@user_orders = UserOrder.find_all_by_master_order_id(@master_order)
			@master_order.deadline_crossed = !@master_order.deadline_crossed
			@master_order.save
		end
		render 'home/show_userorders_of_masterorder', :layout => 'home'
	end  

end
