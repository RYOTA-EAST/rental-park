Rails.application.routes.draw do

  root to: 'parks#index'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  resources :cars
  resources :events, only: :index
  resources :parks do
    resources :events, except: :index do
      member do
        put :cancel
        patch :cancel
      end
    end
    collection do
      get :postal_change
    end
  end

end
