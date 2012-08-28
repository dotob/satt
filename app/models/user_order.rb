  class UserOrder < ActiveRecord::Base
  belongs_to :master_order, :inverse_of => :user_orders
  belongs_to :user, :inverse_of => :user_orders
  has_many :order_items, :inverse_of => :user_order, :dependent => :destroy
  attr_accessible :paid, :master_order_id, :user_id
  
  def self.find_userorder_by_masterorder_id_and_user_id(mo_id, u_id)
  	# Methode verbessern durch find
    where(:user_id => u_id, :master_order_id => mo_id).first 
  end
    
  def self.get_all_user_orders_of_user_and_from_today(user)
    today = Date.today
    find_all_by_user_id(user.id).find_all{|uo| uo.master_order.date_of_order.to_date == today}
  end  
end
