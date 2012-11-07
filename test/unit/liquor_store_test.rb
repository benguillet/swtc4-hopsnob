# == Schema Information
#
# Table name: liquor_stores
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :text
#  city         :string(255)
#  state        :string(255)
#  zip_code     :integer
#  phone_number :string(255)
#  email        :string(255)
#  website      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class LiquorStoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
