class MenuItem < ActiveRecord::Base
  belongs_to :menu, :inverse_of => :menu_items
  has_many :order_items, :inverse_of => :menu_item
  attr_accessible :description, :name, :order_count, :price, :menu_id, :order_number
  attr_accessor :currency_price

  def self.parse_to_regex(str)
    escaped = Regexp.escape(str).gsub('\*','.*?')
    Regexp.new escaped, Regexp::IGNORECASE
  end

  def self.all_menu_items_by_menu_id_and_searchpattern(id, searchpattern)
    if searchpattern && !searchpattern.empty?
      use4like = Rails.configuration.db_use4like 
      menu_items = MenuItem.where("menu_id=? AND (name #{use4like} ? OR order_number = ?)", id, "%#{searchpattern}%", searchpattern).order("order_count DESC, name")   
    else
      menu_items = MenuItem.where('menu_id=?', id).order("order_count DESC, name")   
    end
    return menu_items
  end

  def self.all_menu_items_by_menu_id(id)
    where('menu_id=?', id)
  end

end
