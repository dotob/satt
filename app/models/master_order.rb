class MasterOrder < ActiveRecord::Base
  belongs_to :user, :inverse_of => :master_orders
  belongs_to :menu, :inverse_of => :master_orders
  has_many :user_orders, :inverse_of => :master_order, :dependent => :destroy
  attr_accessible :date_of_order, :deadline_crossed, :user_id, :menu_id
  validates :menu_id, :presence => true

  def self.all_living
    MasterOrder.find_all_by_deadline_crossed(false)    
  end

  def self.living_masterorders_by_user_id(id)
    MasterOrder.where(:user_id => id, :deadline_crossed => false).all
  end
  
  def self.living_masterorders_by_menu_id(id)
    MasterOrder.where(:menu_id => id, :deadline_crossed => false).all
  end

  def self.today_created_master_order_by_user_id(id)
    today = Date.today
    master_order_by_user = MasterOrder.find_all_by_user_id(id)
    master_order_by_user.each do |master_order|
      master_order_date = master_order.date_of_order.to_date
      if today == master_order_date
        return master_order     
      end
    end
    return nil
  end

  def self.all_today_created_master_orders
    searched_master_orders = Array.new
    today = Date.today
    master_orders = MasterOrder.all
    master_orders.each do |mo|
      if mo.date_of_order.to_date == today 
        searched_master_orders << mo
      end 
    end
    return searched_master_orders
  end
end
