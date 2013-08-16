class LineItem < ActiveRecord::Base
  attr_accessible :product, :id, :cart_id, :product_id, :created_at, :updated_at
  belongs_to :product
  belongs_to :cart
end
