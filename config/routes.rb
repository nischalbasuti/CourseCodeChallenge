Rails.application.routes.draw do
  get 'home/index'
  resources :groups
  resources :courses do
    member do
      post 'subscribe'
      delete 'unsubscribe'
      get 'groups'
      get 'new_group'
      post 'create_group'
    end
  end
  devise_for :users, controllers: {
            registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
