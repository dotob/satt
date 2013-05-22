class UserOrdersController < ApplicationController
	respond_to :html, :xml, :json
  layout "home"

  def show
    @current_user_order = UserOrder.find(params[:id])
    @master_order = @current_user_order.master_order
    @order_items = OrderItem.get_all_for_user_order(@current_user_order.id)
  end

  def new
    @user_order = UserOrder.create ({user_id: current_user.id, master_order_id: params[:master_order_id], paid: false})
    flash[:notice] = 'Erfolgreich eine Userorder erstellt'
    redirect_to user_order_path(@user_order)
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
      redirect_to user_order_path(@current_user_order)
    end
  end

  def remove_orderitem
    @master_order = MasterOrder.find(params[:master_order_id])
    @current_user_order = UserOrder.find(params[:user_order_id])
    if @master_order.deadline_crossed
      flash[:error] = 'Masterorder schon geschlossen!'
      redirect_to user_order_path(@current_user_order)
    else
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

  def search_menu_items
    uo = UserOrder.find(params[:user_order_id])
    menu = uo.master_order.menu
    items = menu_items = MenuItem.all_menu_items_by_menu_id(menu.id)
    use4like = Rails.configuration.db_use4like
    menu_items = items.where("name #{use4like} :search or description #{use4like} :search or order_number #{use4like} :search", search: "%#{params[:searchterm]}%").order("order_count DESC")
    result = Result.new
    result.items = menu_items
    result.user_order_id = uo.id
    respond_with result
  end
end

class Result
  attr_accessor :items
  attr_accessor :user_order_id
end
