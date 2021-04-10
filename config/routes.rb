Rails.application.routes.draw do

  root to: 'parks#top_page'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  resources :cars
  resources :events, only: :index
  resources :parks do
    collection do
      get :top_page
      get :search
    end
    resources :events, except: :index do
      # member do
      #   put :cancel
      #   patch :cancel
      # end
    end
    collection do
      get :postal_change
    end
  end

end
