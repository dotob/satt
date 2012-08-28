class OrderItem < ActiveRecord::Base
  belongs_to :user_order, :inverse_of => :order_items
  belongs_to :menu_item, :inverse_of => :order_items
  has_one :master_order, :through => :user_order
  attr_accessible :special_wishes, :user_order_id, :menu_item_id
  delegate :order_number, :to => :menu_item
  
  def self.get_price_of_all_items_of_one_userorder(user_order)
    find_all_by_user_order_id(user_order.id).sum("order_number.price")
  end

  def self.get_price_of_all_items_of_one_masterorder(id)
    get_all_of_master_order(id).sum("order_number.price")
  end

  def self.get_all_for_user_order(user_order_id)
    #where(user_order_id: user_order_id).include(:menu_item).order("menu_items.order_number")
    where(user_order_id: user_order_id).sort &:order_number


    #order_items = OrderItem.find_all_by_user_order_id(user_order_id)
    #order_items.sort! { |a,b| b.menu_item.order_number <=> a.menu_item.order_number }
  end

  def self.get_all_for_user_order_grouped_by_menu_item(user_order_id)
    # Enumerable#group_by  http://apidock.com/rails/Enumerable/group_by

    order_items_grouped = Hash.new
    OrderItem.find_all_by_user_order_id(user_order_id, 
      :select => "menu_item_id", 
      :group => :menu_item_id)
      .each{ |oi|
      order_items_grouped[oi.menu_item.order_number] = OrderItem.find_all_by_user_order_id_and_menu_item_id(user_order_id, oi.menu_item_id)
    }
    return order_items_grouped
  end
  
  def self.get_all_for_master_order_grouped_by_menu_item(master_order_id)
    order_items_grouped = Hash.new
    mois = OrderItem.get_all_of_master_order(master_order_id)
    mois.each do |oi|
      mkey = MenuItem.find(oi.menu_item_id)
      if !order_items_grouped.key?(mkey)
        order_items_grouped[mkey] = Array.new
      end
      order_items_grouped[mkey] << oi
    end
    return order_items_grouped
  end

  def self.get_all_of_master_order(id)
    OrderItem.all.find_all{|oi| oi.master_order.id == id}
  end
end
