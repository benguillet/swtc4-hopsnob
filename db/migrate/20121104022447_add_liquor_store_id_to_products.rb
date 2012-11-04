class AddLiquorStoreIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :liquor_store_id, :integer
  end
end
