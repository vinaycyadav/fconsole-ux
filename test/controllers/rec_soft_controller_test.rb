require 'test_helper'

class RecSoftControllerTest < ActionController::TestCase
  test "should get Home" do
    get :Home
    assert_response :success
  end

end
