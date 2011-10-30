# unit tests are for the model, functional tests are for the controller - particularly in relation to
# the RESTful architecture and verifying that the model, view and controller all work well together

require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)      # get row labeled 'one' from fixture products.yml
    @update = {
        :title       => 'Lorem Ipsum',
        :description => 'Wibbles are fun!',
        :image_url   => 'lorem.jpg',
        :price       => 19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      # replace the following line - which now fails due to validations inserted into the Product model
      # i.e. if you see the @product variable initialization above, the corresponding fixture row fails for example
      # the image_url validation.  Thew @update attribute hash has no such validation failure
      #post :create, :product => @product.attributes
      post :create, :product => @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    # again replace the following line due to validation failures on @product
    #put :update, :id => @product.to_param, :product => @product.attributes
    put :update, :id => @product.to_param, :product => @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end
end
