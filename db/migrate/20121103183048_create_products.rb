class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.decimal :price
      t.integer :number_of_items
      t.decimal :item_volume
      t.string :item_type
      t.timestamps
    end
  end
end
