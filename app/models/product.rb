class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to: beer
  has_and_belongs_to_many :liquore_stores
end
