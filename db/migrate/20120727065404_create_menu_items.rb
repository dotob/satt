class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :order_count
      t.references :menu

      t.timestamps
    end
    add_index :menu_items, :menu_id
  end
end
