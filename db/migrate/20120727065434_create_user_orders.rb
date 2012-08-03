class CreateUserOrders < ActiveRecord::Migration
  def change
    create_table :user_orders do |t|
      t.boolean :paid
      t.references :master_order
      t.references :user

      t.timestamps
    end
    add_index :user_orders, :master_order_id
    add_index :user_orders, :user_id
  end
end
