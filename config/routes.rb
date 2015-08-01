Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users

  root 'google_search_keywords#index'

  #API Routes for mobile devices
  namespace :api do
    namespace :v1 do
      resources :google_search_keywords do

        post 'upload'
        get 'report'
      end
    end
  end

  #Routes for web devices
  resources :google_search_keywords do
    collection do
      post 'upload'
      get 'report'
      get 'delete_all'
      get 'queries'
    end
  end

  mount Resque::Server, :at => "/resque"

end
