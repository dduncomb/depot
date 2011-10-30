# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  image_url   :string(255)
#  price       :decimal(8, 2)
#  created_at  :datetime
#  updated_at  :datetime
#
#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
#---
# Excerpted from "Agile Web Development with Rails, 4rd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
require 'test_helper'

# unit tests are for the model, functional tests are for the controller

class ProductTest < ActiveSupport::TestCase
  # control which fixtures to load from fixtures directory (here, products.yml)
  # note the default for Rails is to load *all* fixtures
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
    product = Product.new(:title       => "My Book Title",
                          :description => "yyy",
                          :image_url   => "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')        # assumption that array holds only the single message here

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')        # assumption that array holds only the single message here

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title       => "My Book Title",
                :description => "yyy",
                :price       => 1,
                :image_url   => image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"    # optional assert parameter output if fail
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"    # optional assert parameter output if fail
    end
  end

  test "product is not valid without a unique title" do

    # Rails automatically creates a method of same name as the fixture (here, products)
    # and accepts the name of a row in the fixture file (e.g., one, two, or ruby in products.yml)
    product = Product.new(:title       => products(:ruby).title,
                          :description => "yyy",
                          :price       => 1,
                          :image_url   => "fred.gif")

    # save should fail because our fixture file - which is loaded at the start of every unit test -
    # specifies to load 3 rows, including a third row (named ruby in the fixture products.yml) -
    # which has the title being tested for!
    assert !product.save     # save should fail  - the title
    assert_equal "has already been taken", product.errors[:title].join('; ')    # assuming one error only in array
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(:title       => products(:ruby).title,
                          :description => "yyy",
                          :price       => 1,
                          :image_url   => "fred.gif")

    assert !product.save       # save should fail
    assert_equal I18n.translate('activerecord.errors.messages.taken'),  # alt. comparison w/ built-in error msg table
                 product.errors[:title].join('; ')                      # assuming one error only in array
  end

end