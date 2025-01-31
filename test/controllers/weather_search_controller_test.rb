require "test_helper"

class WeatherSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get root_url, params: { query: "Hyderabad" }
    assert_response :success
  end
end
