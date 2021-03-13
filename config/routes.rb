Rails.application.routes.draw do

  root to: 'parks#index'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  resources :cars, only: [:new, :create, :edit, :update, :destroy]
  resources :parks do
    collection do
      get :postal_change
    end
  end

end
