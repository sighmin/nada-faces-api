require "test_helper"

module Api
  class FacesControllerTest < ActionDispatch::IntegrationTest
    test "POST /api/faces uploads a face to rekognition and returns it's face_id" do
      params = { face: { file_id: "face.jpg" } }
      RekognitionFake.stub_upload

      post api_faces_path(secret: ENV.fetch("SECRET")), params: params

      assert_response :success
      assert_equal "application/json", response.content_type
      assert_equal("3aaf09d1-7cb5-4589-bccd-934b93c7cce3", response_hash["face_id"])
      assert_equal("e37d6a4e-2e6b-3cf2-b5ad-982f2df306e5", response_hash["image_id"])
      assert_equal(100.0, response_hash["confidence"])
      assert response_hash["response_data"].present?
    end

    test "POST /api/search returns matches for the file provided" do
      params = { search: { file_id: "face.jpg" } }
      RekognitionFake.stub_search

      post api_search_path(secret: ENV.fetch("SECRET")), params: params

      assert_response :success
      assert_equal "application/json", response.content_type
      matches = response_hash["matches"]
      assert_equal 1, matches.length
      match = matches.first
      assert_equal("3aaf09d1-7cb5-4589-bccd-934b93c7cce3", match["face_id"])
      assert_equal(99.99999237060547, match["similarity"])
      assert response_hash["response_data"].present?
    end

    def response_hash
      @response_hash ||= JSON.load(response.body)
    end
  end
end
