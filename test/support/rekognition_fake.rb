module RekognitionFake
  extend self

  def stub_upload
    Aws::Rekognition::Client.
      any_instance.
      stubs(:index_faces).
      returns(fake_upload)
  end

  def stub_search
    Aws::Rekognition::Client.
      any_instance.
      stubs(:search_faces_by_image).
      returns(fake_search)
  end

  def fake_search
    {:searched_face_bounding_box=>
     {:width=>0.40152809023857117,
      :height=>0.5388878583908081,
      :left=>0.31203436851501465,
      :top=>0.32581183314323425},
      :searched_face_confidence=>100.0,
      :face_matches=>
     [{:similarity=>99.99999237060547,
       :face=>
     {:face_id=>
      "3aaf09d1-7cb5-4589-bccd-934b93c7cce3",
        :bounding_box=>
      {:width=>0.401528000831604,
       :height=>0.5388879776000977,
       :left=>0.312034010887146,
       :top=>0.3258120119571686},
       :image_id=>"e37d6a4e-2e6b-3cf2-b5ad-982f2df306e5",
       :external_image_id=>"face.jpg",
       :confidence=>100.0}}],
       :face_model_version=>"4.0"}
  end

  def fake_upload
    {:face_records=>
     [{:face=>
       {:face_id=>
        "3aaf09d1-7cb5-4589-bccd-934b93c7cce3",
          :bounding_box=>
        {:width=>0.40152809023857117,
         :height=>0.5388878583908081,
         :left=>0.31203436851501465,
         :top=>0.32581183314323425},
         :image_id=>"e37d6a4e-2e6b-3cf2-b5ad-982f2df306e5",
         :external_image_id=>"face.jpg",
         :confidence=>100.0},
         :face_detail=>
        {:bounding_box=>
         {:width=>0.40152809023857117,
          :height=>0.5388878583908081,
          :left=>0.31203436851501465,
          :top=>0.32581183314323425},
          :landmarks=>
         [{:type=>"eyeLeft",
           :x=>0.4060269296169281,
           :y=>0.5164172649383545},
           {:type=>"eyeRight",
            :x=>0.5863754153251648,
            :y=>0.5211580991744995},
            {:type=>"mouthLeft",
             :x=>0.4173072278499603,
             :y=>0.7079474925994873},
             {:type=>"mouthRight",
              :x=>0.5667593479156494,
              :y=>0.7121710181236267},
              {:type=>"nose",
               :x=>0.4862176477909088,
               :y=>0.6192609667778015}],
               :pose=>{:roll=>2.043330192565918,
                       :yaw=>-0.4558669328689575,
                       :pitch=>6.8689422607421875},
                       :quality=>{:brightness=>91.9506607055664,
                                  :sharpness=>73.32209777832031},
                                  :confidence=>100.0}}],
                                  :face_model_version=>"4.0",
                                  :unindexed_faces=>[]}
  end
end
