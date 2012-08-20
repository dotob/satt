class HomeController < ApplicationController
  
  respond_to :html
  
  def index
    # fall 1: keine userorder, keine masterorder --> neue Masterorder erstellen
    # fall 2: 1 masterorder keine userorder --> Bestellseite der bestehenden Masterorder anzeigen
    # fall 3: mehrere masterorders, keine userorder --> "Du hast noch keine Bestellung aufgegeben. Bitte wähle einen Bestellservice aus."
    # fall 4: 1 userorder --> Userorder anzeigen
    # fall 5: mehrere userorders --> "Bitte wähle eine deiner bestehenden Bestellungen aus:" Liste der Userorders anzeigen
    
    # sicher, dass wir die Userorders vom Benutzer brauchen an dieser Stelle?
    # brauchen wir nicht in diesem Fall die UserOrders vom Benutzer und von den masterorders von heute?
    @master_orders = MasterOrder.all_today_created_master_orders

    user_orders = UserOrder.get_all_user_orders_of_user_and_from_today(current_user)
    if user_orders.empty?
      if @master_orders.empty?
        # fall 1
        redirect_to choose_menu_url and return
        #render 'home/create_masterorder', :layout => 'home'
      elsif @master_orders.length == 1
        # fall 2
        @master_order = @master_orders[0]
        show_user_order
      else
        # fall 3
        render 'home/choose_masterorder', :layout => 'home'
      end
    elsif user_orders.length == 1
      # fall 4
      redirect_to user_order_path(user_orders.first)
    else
      # fall 5
      render 'home/choose_masterorder', :layout => 'home'
    end     
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
end