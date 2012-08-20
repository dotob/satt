class UserOrdersController < ApplicationController
	respond_to :html, :xml, :json
  layout "home"

  def show
    @current_user_order = UserOrder.find(params[:id])
    @master_order = @current_user_order.master_order
    @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
  end

  def add_orderitem
    @master_order = MasterOrder.find(params[:master_order_id])
    if @master_order.deadline_crossed
      flash[:error] = 'Masterorder schon geschlossen!'
      redirect_to root_path 
    else
      @current_user_order = UserOrder.find(params[:user_order_id])
      menuitem_id = params[:menu_item_id].to_i
      menu_item = MenuItem.find(menuitem_id)
      OrderItem.create ({special_wishes: "", user_order_id: @current_user_order.id, menu_item_id: menu_item.id })
      menu_item.order_count += 1 
      menu_item.save
      @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
      redirect_to user_order_path(@current_user_order)
    end
  end

  def remove_orderitem
    @master_order = MasterOrder.find(params[:master_order_id])
    if @master_order.deadline_crossed
      flash[:error] = 'Masterorder schon geschlossen!'
      redirect_to root_path 
    else
      @current_user_order = UserOrder.find(params[:user_order_id])
      orderitem = OrderItem.find(params[:orderitem_id])
      menu_item = orderitem.menu_item 
      menu_item.order_count -= 1
      menu_item.save
      OrderItem.delete(orderitem)
      @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
      redirect_to user_order_path(@current_user_order)
    end
  end

  def add_specialwishes
    @master_order = MasterOrder.find(params[:master_order_id])
    @current_user_order = UserOrder.find(params[:user_order_id])
    orderitem = OrderItem.find(params[:orderitem_id])
    orderitem.special_wishes = params[:specialwishes]
    orderitem.save
    @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
    redirect_to user_order_path(@current_user_order)
  end
end
