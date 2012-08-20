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
      elsif @master_orders.length == 1
        # fall 2
        @master_order = @master_orders.first
        redirect_to new_user_order_path :master_order_id => @master_order.id
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

end