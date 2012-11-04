class AddBeerIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :beer_id, :integer
  end
end
