class MenuItem < ActiveRecord::Base
  belongs_to :menu, :inverse_of => :menu_items
  has_many :order_items, :inverse_of => :menu_item
  attr_accessible :description, :name, :order_count, :price, :menu_id, :order_number

  def self.parse_to_regex(str)
    escaped = Regexp.escape(str).gsub('\*','.*?')
    Regexp.new escaped, Regexp::IGNORECASE
  end

  def self.all_menu_items_by_menu_id(id, searchpattern)
      if searchpattern && !searchpattern.empty?
        menu_items = MenuItem.where('menu_id=? AND (name LIKE "%?%" OR order_number = ?)', id, searchpattern, searchpattern).order("order_count DESC, name")   
      else
        menu_items = MenuItem.where('menu_id=?', id).order("order_count DESC, name")   
      end
      return menu_items

      menu_items = MenuItem.find_all_by_menu_id(id)   
      # suche alle die zum pattern passen 
      if searchpattern && !searchpattern.empty?
        menu_items = menu_items.find_all{ |item| 
          self.parse_to_regex(searchpattern) =~ item.name
        }
      end
      return menu_items.sort! { |a,b| b.order_count <=> a.order_count }
  end

end