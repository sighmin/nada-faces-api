Rails.application.routes.draw do
  namespace :api do
    post "faces" => "faces#create", as: :faces
    post "search" => "faces#search", as: :search
  end
end
