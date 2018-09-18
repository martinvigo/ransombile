require 'test_helper'

class RansombileControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ransombile_index_url
    assert_response :success
  end

end
