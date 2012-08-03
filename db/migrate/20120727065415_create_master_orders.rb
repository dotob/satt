class CreateMasterOrders < ActiveRecord::Migration
  def change
    create_table :master_orders do |t|
      t.datetime :date_of_order
      t.boolean :deadline_crossed
      t.references :user
      t.references :menu

      t.timestamps
    end
    add_index :master_orders, :user_id
    add_index :master_orders, :menu_id
  end
end
