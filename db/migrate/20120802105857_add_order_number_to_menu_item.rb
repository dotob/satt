class AddOrderNumberToMenuItem < ActiveRecord::Migration
  def change
    add_column :menu_items, :order_number, :string
  end
end
