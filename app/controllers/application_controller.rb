class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_cart
  	Cart.find(session[:cart_id])	#starts by getting the :cart_id from the session object
  rescue ActiveRecord::RecordNotFound	#attempts to find a cart corresponding to this id
  	cart = Cart.create			#if NOT create a new Cart
  	session[:cart_id] = cart.id 	#store the id of the created cart into the session
  	cart 
  end								#return the new cart
end
