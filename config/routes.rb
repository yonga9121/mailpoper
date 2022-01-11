Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  

  namespace :oauth do
    get :auth
  end 

  namespace :users do
    post :create
    get :welcome
  end 
  root to: "users#welcome"

end
