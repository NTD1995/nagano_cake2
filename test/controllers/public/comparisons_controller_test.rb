require "test_helper"

class Public::ComparisonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_comparisons_index_url
    assert_response :success
  end

  test "should get create" do
    get public_comparisons_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_comparisons_destroy_url
    assert_response :success
  end
end
