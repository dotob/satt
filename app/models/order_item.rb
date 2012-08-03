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
end
