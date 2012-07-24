class Menu < ActiveRecord::Base
  has_many :menu_items, :dependent => :destroy, :inverse_of => :menu
  attr_accessible :description, :name, :phone
end
