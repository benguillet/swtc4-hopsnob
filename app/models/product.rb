class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :beers
  has_and_belongs_to_many :liquor_stores
end
