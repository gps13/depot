class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :line_items, :dependent => :destroy
  # The :dependent => :destroy part indicates that the existence of line items is dependent on
  # the existence of the cart. If we destroy a cart, deleting it from the database, we’ll
  # want Rails also to destroy any line items that are associated with that cart.
end
