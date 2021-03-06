require "test_helper"

module Api
  class FacesControllerAuthTest < ActionDispatch::IntegrationTest
    test "POST /faces is protected with a secret" do
      ENV.expects(:fetch).with("SECRET").returns("hahaha")
      post api_faces_path
      assert_unauthorized(response)
    end

    test "POST /search is protected with a secret" do
      ENV.expects(:fetch).with("SECRET").returns("hahaha")
      post api_search_path
      assert_unauthorized(response)
    end

    def assert_unauthorized(response)
      assert_equal 403, response.status
      assert_equal({
        "error" => "Request not authorized"
      }, JSON.load(response.body))
    end
  end
end
