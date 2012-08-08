class AddHasNumbersToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :has_numbers, :bool, :default => true
  end
end
