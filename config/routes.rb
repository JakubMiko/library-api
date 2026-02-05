Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
      resources :books, only: [ :index, :show, :create, :destroy ]
      resources :borrowings, only: [ :create, :update ]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
