require "test_helper"

class Public::FaqsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_faqs_index_url
    assert_response :success
  end
end
