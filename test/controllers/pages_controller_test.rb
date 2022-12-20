require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get landing" do
    get pages_landing_url
    assert_response :success
  end

  test "should get error" do
    get pages_error_url
    assert_response :success
  end
end
