class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :beers, :color, :style
  end
end
