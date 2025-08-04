require "test_helper"

class Public::RestockRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_restock_requests_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_restock_requests_destroy_url
    assert_response :success
  end
end
