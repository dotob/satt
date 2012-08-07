class OrderItem < ActiveRecord::Base
  belongs_to :user_order, :inverse_of => :order_items
  belongs_to :menu_item, :inverse_of => :order_items
  has_one :master_order, :through => :user_order
  attr_accessible :special_wishes, :user_order_id, :menu_item_id
  
  def self.get_price_of_all_items_of_one_userorder(id)
  	order_items = OrderItem.find_all_by_user_order_id(id)
  	price = 0
  	order_items.each do |orderitem|
  		price = price + orderitem.menu_item.price
    end
    return price  
  end

  def self.get_all_for_user_order(user_order_id)
    order_items = OrderItem.find_all_by_user_order_id(user_order_id)
    order_items.sort! { |a,b| b.menu_item.order_number <=> a.menu_item.order_number }
  end

  def self.get_all_for_user_order_grouped_by_menu_item(user_order_id)
    order_items_grouped = Hash.new
    OrderItem.find_all_by_user_order_id(user_order_id, 
      :select => "menu_item_id", 
      :group => :menu_item_id)
      .each{ |oi|
      order_items_grouped[oi.menu_item.order_number] = OrderItem.find_all_by_user_order_id_and_menu_item_id(user_order_id, oi.menu_item_id)
    }
    return order_items_grouped
  end
end
