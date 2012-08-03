class UserOrder < ActiveRecord::Base
  belongs_to :master_order, :inverse_of => :user_orders
  belongs_to :user, :inverse_of => :user_orders
  has_many :order_items, :inverse_of => :user_order, :dependent => :destroy
  attr_accessible :paid, :master_order_id, :user_id
  
  def self.find_userorder_by_masterorder_id_and_user_id(mo_id, u_id)
  	# Methode verbessern durch find
     UserOrder.where(:user_id => u_id, :master_order_id => mo_id).first 
  end
    
  def self.find_userorders_by_masterorder_ids(ids)
    end  
  
end
