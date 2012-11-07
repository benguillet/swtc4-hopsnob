# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  price           :decimal(, )
#  number_of_items :integer
#  item_volume     :decimal(, )
#  item_type       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  liquor_store_id :integer
#  beer_id         :integer
#

class Product < ActiveRecord::Base
  attr_accessible :price, :number_of_items,:item_volume, :item_type, :liquor_store_id, :beer_id
  belongs_to :beers
  has_and_belongs_to_many :liquor_stores
end
