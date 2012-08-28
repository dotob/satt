class MasterOrder < ActiveRecord::Base
  belongs_to :user, :inverse_of => :master_orders
  belongs_to :menu, :inverse_of => :master_orders
  has_many :user_orders, :inverse_of => :master_order, :dependent => :destroy
  attr_accessible :date_of_order, :deadline_crossed, :user_id, :menu_id
  validates :menu_id, :presence => true
  scope :today, lambda { where("DATE(date_of_order) == DATE('NOW')") } #may code timezone problems

  def self.all_living
    find_all_by_deadline_crossed(false)    
  end

  def self.living_masterorders_by_user_id(id)
    where(:user_id => id, :deadline_crossed => false)
  end
  
  def self.living_masterorders_by_menu_id(id)
    where(:menu_id => id, :deadline_crossed => false)
  end

  def self.today_created_master_order_by_user_id(id)
    today.where(:user_id => id) #.detect{|m| m.date_of_order.to_date == Date.today}
  end

  def self.all_today_created_master_orders
    today
    #all.find_all{|m| m.date_of_order.to_date == Date.today}
  end

end
