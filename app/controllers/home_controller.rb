class HomeController < ApplicationController
  
  respond_to :html
  
  def index
    @master_order_id = params[:master_order_id]
    @master_orders = MasterOrder.all_today_created_master_orders
    # fall 1: keine userorder, keine masterorder --> neue Masterorder erstellen
    # fall 2: 1 masterorder keine userorder --> Bestellseite der bestehenden Masterorder anzeigen
    # fall 3: mehrere masterorders, keine userorder --> "Du hast noch keine Bestellung aufgegeben. Bitte wähle einen Bestellservice aus."
    # fall 4: 1 userorder --> Userorder anzeigen
    # fall 5: mehrere userorders --> "Bitte wähle eine deiner bestehenden Bestellungen aus:" Liste der Userorders anzeigen
    
    # sicher, dass wir die Userorders vom Benutzer brauchen an dieser Stelle?
    # brauchen wir nicht in diesem Fall die UserOrders vom Benutzer und von den masterorders von heute?
    user_orders = UserOrder.find_all_by_user_id(current_user.id)
    
    if user_orders.empty?
         if @master_orders.empty?
           # fall 1
           render 'home/create_masterorder', :layout => 'home'
         elsif @master_orders.length == 1
           # fall 2
           @master_order = @master_orders[0]
           UserOrder.create ({user_id: current_user.id, master_order_id: @master_order.id, paid: false})
           show_user_order
         else
           # fall 3
           render 'home/choose_masterorder', :layout => 'home'
         end
    elsif user_orders.length == 1 || !@master_order_id.nil?
      # fall 4
      @master_order = @master_order_id.nil? ? @master_orders[0] : MasterOrder.find(@master_order_id.to_i)
      show_user_order
    else
      # fall 5
      render 'home/choose_masterorder', :layout => 'home'
    end     
  end

  def show_user_order
      @master_order_id = @master_order_id.nil? ? params[:master_order_id] : @master_order_id
      @master_order = @master_order.nil? ? MasterOrder.find(@master_order_id.to_i) : @master_order
      @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
      render 'home/show_userorder', :layout => 'home'
  end

  def create_master_order
    MasterOrder.create ({ menu_id: params[:menu], deadline_crossed: false, user_id: current_user.id, date_of_order: DateTime.now })
    flash[:notice] = 'Erfolgreich eine Masterorder erstellt'
    redirect_to root_path
  end
  
  def add_orderitem
     @master_order = MasterOrder.find(params[:master_order_id].to_i)
     @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
     menuitem_id = params[:menu_item_id].to_i
     @menu_item = MenuItem.find(menuitem_id)
     OrderItem.create ({special_wishes: "", user_order_id: @current_user_order.id, menu_item_id: @menu_item.id })
     @menu_item.order_count += 1 
     @menu_item.save
     render 'home/show_userorder', :layout => 'home'
  end

  def remove_orderitem
    @master_order_id = params[:master_order_id].to_i
    @master_order = MasterOrder.find(@master_order_id)
    @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
    orderitem_id = params[:orderitem_id].to_i
    orderitem = OrderItem.find(orderitem_id)
    menu_item = orderitem.menu_item 
    menu_item.order_count = menu_item.order_count - 1
    menu_item.save
    OrderItem.delete(orderitem)
    render 'home/show_userorder', :layout => 'home'
  end

  def add_specialwishes
    orderitem_id = params[:orderitem_id].to_i
    masterorder_id = params[:master_order_id].to_i
    @master_order = MasterOrder.find(masterorder_id)
    @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order.id , current_user.id)
    orderitem = OrderItem.find(orderitem_id)
    orderitem.special_wishes = params[:specialwishes]
    orderitem.save
    render 'home/show_userorder', :layout => 'home'
  end

  def choose_masterorder
     @master_order_id = params[:id].to_i
     @master_order = MasterOrder.find(@master_order_id)
     @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order_id , current_user.id)
     if @current_user_order.nil?
      UserOrder.create ({user_id: current_user.id, master_order_id: @master_order_id, paid: false})
     end
     @current_user_order = UserOrder.find_userorder_by_masterorder_id_and_user_id(@master_order_id , current_user.id)
     render 'home/show_userorder', :layout => 'home'
  end
  
  def show_userorders_of_masterorder
    # User kann nur eine MasterOrder anlegen, die deadline_crossed true hat
    @master_order = MasterOrder.today_created_master_order_by_user_id(current_user.id)
    @user_orders = UserOrder.find_all_by_master_order_id(@master_order)
    render 'home/show_userorders_of_masterorder', :layout => 'home'
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

  #def sort_order_items
   # orderitem_id = params[:orderitem_id].to_i
    #masterorder_id = params[:master_order_id].to_i
  #end
  #return order_items.sort! { |a,b| b.orderitem.name <=> a.orderitem.name }

end