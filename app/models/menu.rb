class Menu < ActiveRecord::Base
  has_many :menu_items, :inverse_of => :menu, :dependent => :destroy
  has_many :master_orders, :inverse_of => :menu
  attr_accessible :description, :name, :phone, :has_numbers
end
