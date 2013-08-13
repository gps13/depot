require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products
  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
	assert product.errors[:price].any?
	assert product.errors[:image_url].any?
  end
  test "product price must be positive" do
	product = Product.new(:title => "My Book Title" , :description => "yyy" , :image_url => "zzz.jpg" )
	product.price = -1
	assert product.invalid?
	assert_equal "must be greater than or equal to 0.01" ,
	product.errors[:price].join('; ' )
	product.price = 0
	assert product.invalid?
	assert_equal "must be greater than or equal to 0.01" ,
	product.errors[:price].join('; ' )
	product.price = 1
	assert product.valid?
  end
  def new_product(image_url)
	Product.new(:title => "My Book Title" ,
	:description => "yyy" ,
	:price => 1,
	:image_url => image_url)
  end
  test "image url" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
				http://a.b.c/x/y/z/fred.gif }
	bad = %w{ fred.doc fred.gif/more fred.gif.more }
	ok.each do |image_name|
		assert new_product(image_name).valid?, "#{image_name} shouldn't be invalid"
	end
	bad.each do |image_name|
		assert new_product(image_name).invalid?, "#{image_name} shouldn't be valid"           
	end
  end
  test "product is not valid without a unique title" do
  	product = Product.new(:title => products(:ruby).title,
  						  :description => "yyy",
  						  :price => 1,
						  :image_url => "fred.gif")
  	assert !product.save
  	assert_equal "has already been taken", product.errors[:title].join('; ' ) 
  end
 	test "product is not valid without a unique title - i18n" do
		product = Product.new(:title => products(:ruby).title,
								:description => "yyy" ,
								:price => 1,
								:image_url => "fred.gif" )
		assert !product.save
		assert_equal I18n.translate('activerecord.errors.messages.taken' ),
		product.errors[:title].join('; ' )

  	end
  # 	test "product title must be at least ten characters long" do
		# product = products(:ruby)
		# assert product.title.length <10?, "length of title should be > 10 chars"
  # 	end
  	test "title is at least 10 characters long OPTION 1" do
    product = Product.new(:price        =>  9.99,
                          :description  =>  "yyy",
                          :image_url    =>  "zzz.jpg")

    product.title = "This is an acceptable title" 
    assert product.valid?

    product.title = "So is this" 
    assert product.valid?

    product.title = "not this" 
    assert product.invalid?
    assert_equal "must be at least 10 characters long.", 
      product.errors[:title].join('; ')
  	end

  	test "product title must be at least ten characters long OPTION 2" do
  		product = products(:ruby)
  		assert product.valid?, "product title shouldn't be invalid" 

  		product.title = product.title.first(9)
    	assert product.invalid?, "product title shouldn't be valid"
  	end
end
