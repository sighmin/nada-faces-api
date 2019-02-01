module FaceService
  extend self

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/Rekognition/Client.html#index_faces-instance_method
  def upload(file_id)
    response = client.index_faces(upload_params(file_id))
    format_upload_response(response).tap { |data|
      Rails.logger.debug "[data] rekognition index_faces response data"
      Rails.logger.debug data.inspect
    }
  end

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/Rekognition/Client.html#search_faces_by_image-instance_method
  def search(file_id)
    response = client.search_faces_by_image(search_params(file_id))
    format_search_response(response).tap { |data|
      Rails.logger.debug "[data] rekognition index_faces response data"
      Rails.logger.debug data.inspect
    }
  end

  def flush
    params = { collection_id: collection_id }
    client.delete_collection(params) &&
      client.create_collection(params)

    s3_client.list_objects({
      bucket: bucket,
      max_keys: 1000,
    }).contents.each { |object|
      s3_client.delete_object({
        bucket: bucket,
        key: object.key,
      })
    }
  end

  private

  def format_upload_response(response)
    response_hash = response.to_h
    face_obj = response_hash.fetch(:face_records, []).max { |a,b|
      a.dig(:face, :confidence) <=> b.dig(:face, :confidence)
    }

    {
      face_id: face_obj.dig(:face, :face_id),
      image_id: face_obj.dig(:face, :image_id),
      confidence: face_obj.dig(:face, :confidence),
      response_data: response_hash,
    }
  end

  def upload_params(file_id)
    {
      collection_id: collection_id,
      image: {
        s3_object: {
          bucket: bucket,
          name: file_id,
        },
      },
      external_image_id: file_id,
      detection_attributes: ["DEFAULT"], # accepts DEFAULT, ALL
      max_faces: 1,
      quality_filter: "NONE", # accepts NONE, AUTO
    }
  end

  def format_search_response(response)
    response_hash = response.to_h

    {
      matches: response_hash.fetch(:face_matches, []).map { |obj|
        {
          face_id: obj.dig(:face, :face_id),
          similarity: obj.fetch(:similarity),
        }
      },
      response_data: response_hash,
    }
  end

  def search_params(file_id)
    {
      collection_id: collection_id,
      face_match_threshold: 90,
      image: {
        s3_object: {
          bucket: bucket,
          name: file_id,
        },
      },
      max_faces: 1,
    }
  end

  def client
    Aws::Rekognition::Client.new(region: ENV.fetch("AWS_REGION"))
  end

  def s3_client
    Aws::S3::Client.new(region: ENV.fetch("AWS_REGION"))
  end

  def collection_id
    ENV.fetch("REKOG_COLLECTION")
  end

  def bucket
    ENV.fetch("AWS_S3_BUCKET")
  end
end
