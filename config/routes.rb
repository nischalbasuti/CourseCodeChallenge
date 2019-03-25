Rails.application.routes.draw do
  get 'home/index'
  resources :groups do 
    member do 
      get 'add_subscribers'
      put 'add_subscriber'
      delete 'remove_subscriber'
      put 'update_name'
      get 'edit_name'
      get 'edit_project_topic'
      put 'update_project_topic'
    end
  end

  resources :courses do
    member do
      post 'subscribe'
      delete 'unsubscribe'
      get 'groups'
      get 'new_group'
      post 'create_group'
      get 'subscribers'
    end
  end

  devise_for :users, controllers: {
            registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
