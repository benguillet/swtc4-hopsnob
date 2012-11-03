class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :brand
      t.string :name
      t.string :color
      t.string :country
      t.string :city
      t.string :state
      t.string :malt
      t.decimal :ibu
      t.integer :abv
      t.timestamps
    end
  end
end
