class MenuItem < ActiveRecord::Base
  belongs_to :menu, :inverse_of => :menu_items
  attr_accessible :description, :name, :order_count, :price, :menu_id
end
