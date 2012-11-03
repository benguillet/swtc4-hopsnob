class CreateLiquorStores < ActiveRecord::Migration
  def change
    create_table :liquor_stores do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.number :phone_number
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
