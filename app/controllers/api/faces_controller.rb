module Api
  class FacesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_request

    # POST /api/faces { face: { file_id: face_id/file_id } }
    def create
      data = FaceService.upload(upload_face_id)
      render json: data
    end

    # POST /api/search { search: { file_id: s3_file_key } }
    def search
      data = FaceService.search(search_file_id)
      render json: data
    end

    private

    def upload_face_id
      params.require(:face).permit(:file_id)[:file_id]
    end

    def search_file_id
      params.require(:search).permit(:file_id)[:file_id]
    end

    def authenticate_request
      unless params[:secret] == ENV.fetch("SECRET")
        render status: 403, json: {
          error: "Request not authorized"
        }
      end
    end
  end
end
