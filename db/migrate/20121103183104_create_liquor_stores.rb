class CreateLiquorStores < ActiveRecord::Migration
  def change
    create_table :liquor_stores do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.decimal :latitude
      t.decimal :longitude
      t.string :phone_number
      t.string :email
      t.string :website
      t.timestamps
    end
  end
end
