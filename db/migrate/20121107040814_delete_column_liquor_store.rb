class DeleteColumnLiquorStore < ActiveRecord::Migration
  def change
    remove_column :liquor_stores, :latitude, :longitude
  end
end
