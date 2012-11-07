# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

CSV.foreach("#{Rails.root}/lib/data/beers.csv") do |row|
    Beer.create(
        :brand => row[0],
        :name => row[1],
        :style => row[2],
        :country => row[3],
        :city => row[4],
        :state => row[5],
        :malt => row[6],
        :ibu => row[7],
        :abv => row[8]
    )
end

CSV.foreach("#{Rails.root}/lib/data/liquor_stores.csv") do |row|
    LiquorStore.create(
        :name => row[0],
        :address => row[1],
        :city => row[2],
        :state => row[3],
        :zip_code => row[4],
        :phone_number => row[5],
        :email => row[6],
        :website => row[7]
    )
end

CSV.foreach("#{Rails.root}/lib/data/products.csv") do |row|
    Product.create(
        :price => row[0],
        :number_of_items => row[1],
        :item_volume => row[2],
        :item_type => row[3],
        :liquor_store_id => row[4],
        :beer_id => row[5]
    )
end

LiquorStore.create(name: 'Northfield Liquor Store', address: '116 5th Street West', city: 'Northfield', state:'MN', zip_code: '55057')
Product.create(beer_id: 3, liquor_store_id: 27)
