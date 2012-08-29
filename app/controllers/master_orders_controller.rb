class MasterOrdersController < ApplicationController
	respond_to :html, :xml, :json
    layout "home"

	def choose_menu
		render 'master_orders/choose_menu'
	end

	def show
		@master_order = MasterOrder.find(params[:id])
		@user_orders = UserOrder.find_all_by_master_order_id(@master_order.id).find_all{|uo| !uo.order_items.empty?}
		@is_my_order = @master_order.user == current_user
		unpaid_user_orders = @user_orders.find_all{|uo| !uo.paid}
		@unpaid_users = unpaid_user_orders.map{|uo| uo.user.name}
		sum = 0
		unpaid_user_orders.map{|uo| sum += OrderItem.get_price_of_all_items_of_one_userorder(uo)}
		@unpaid_money = sum
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
	    @user_order = UserOrder.find(params[:user_order_id])
	    @master_order = @user_order.master_order
	    @user_order.paid = !@user_order.paid
	    @user_order.save
	    redirect_to master_order_path(@master_order)
	end

	def close_master_order
		@master_order = MasterOrder.find(params[:master_order_id])
		@master_order.deadline_crossed = !@master_order.deadline_crossed
		@master_order.save
	    redirect_to master_order_path(@master_order)
	end  

	def mail_users_lunch_arrived
		master_order = MasterOrder.find(params[:master_order_id])
		MasterOrderMailer.lunch_arrived_emails(master_order).deliver
		flash[:notice] = 'Mails versendet'
	    redirect_to master_order_path(master_order)
	end
end
