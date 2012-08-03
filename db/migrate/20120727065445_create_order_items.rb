class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.text :special_wishes
      t.references :user_order
      t.references :menu_item

      t.timestamps
    end
    add_index :order_items, :user_order_id
    add_index :order_items, :menu_item_id
  end
end
