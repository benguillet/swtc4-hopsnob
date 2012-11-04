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

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
