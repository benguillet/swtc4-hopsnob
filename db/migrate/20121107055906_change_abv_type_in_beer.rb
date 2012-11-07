class ChangeAbvTypeInBeer < ActiveRecord::Migration
  def up
    change_column :beers, :abv, :decimal
  end

  def down
    change_column :beers, :abv, :integer
  end
end
