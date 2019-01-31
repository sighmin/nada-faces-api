# Nada faces API

An api to store and search faces using Amazon Rekognition. Consumed from
[nada](https://github.com/sighmin/nada).

<img src="https://media1.giphy.com/media/l4FGDDdbkaN9O3uCI/giphy.gif"
alt="faces"/>

## Setup

System dependencies:

- Ruby 2.6.0
- Postgres 10+
- Heroku cli

Run the setup script:

```
$ bin/setup
```

Run the development server:

```
$ heroku local
```

## Tests

```
$ rails t test/*
```

## API

Auth requires a super secret key sent as a query parameter in the request
URL: `/api/endpoint?secret=super-secret-key`

### POST /api/faces

Upload an image with a face.

```
POST /api/faces {
  face: {
    file_id: <s3filekey_of_face_present_in_image>,
  }
}

{
  face_id: face_id,        # Face ID assigned by Rekognition
  image_id: image_id,      # Image ID assigned by Rekognition
  confidence: confidence,  # Confidence that there's in face a face
  response: response_data, # Entire response hash from Rekognition
}
```

### POST /api/search

Search for similar faces.

```
POST /api/search {
  search: {
    file_id: <s3filekey_of_face_present_in_image>
  }
}

{
  matches: [{
    face_id: face_id,      # Face ID identified in face collection
    similarity: 0.96,      # Similarity from face in provided image
  }],
  response: response_data, # Entire response hash from Rekognition
}
```
