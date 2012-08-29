class UserOrderController < ApplicationController
	respond_to :html, :xml, :json


  def show_user_order
      @master_order_id = @master_order_id.nil? ? params[:master_order_id] : @master_order_id
      @master_order = @master_order.nil? ? MasterOrder.find(@master_order_id.to_i) : @master_order
      @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
      @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
      render 'home/show_userorder', :layout => 'home'
  end
   
  def add_orderitem
    @current_user_order = UserOrder.find(params[:user_order_id])
    @master_order = @current_user_order.master_order
    if @master_order.deadline_crossed
      flash[:error] = 'Masterorder schon geschlossen!'
      redirect_to root_path 
    else
      menu_item = MenuItem.find(params[:menu_item_id])
      OrderItem.create ({special_wishes: "", user_order_id: @current_user_order.id, menu_item_id: menu_item.id })
      menu_item.order_count += 1 
      menu_item.save
      @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
      render 'home/show_userorder', :layout => 'home'
    end
  end

  def remove_orderitem
    if @master_order.deadline_crossed
      flash[:error] = 'Masterorder schon geschlossen!'
      redirect_to root_path 
    else
      @master_order_id = params[:master_order_id].to_i
      @master_order = MasterOrder.find(@master_order_id)
      @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
      orderitem_id = params[:orderitem_id].to_i
      orderitem = OrderItem.find(orderitem_id)
      menu_item = orderitem.menu_item 
      menu_item.order_count -= 1
      menu_item.save
      OrderItem.delete(orderitem)
      @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
      render 'home/show_userorder', :layout => 'home'
    end
  end

  def add_specialwishes
    orderitem_id = params[:orderitem_id].to_i
    masterorder_id = params[:master_order_id].to_i
    @master_order = MasterOrder.find(masterorder_id)
    @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
    orderitem = OrderItem.find(orderitem_id)
    orderitem.special_wishes = params[:specialwishes]
    orderitem.save
    @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
    render 'home/show_userorder', :layout => 'home'
  end
end
