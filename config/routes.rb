Rails.application.routes.draw do
  get 'home/index'

  resources :groups do 
    member do 
      put 'update_name'
      get 'edit_name'

      get 'edit_project_topic'
      put 'update_project_topic'

      get 'edit_grade'
      put 'update_grade'

      post 'project', to: "projects#upload_project"
      delete 'project',  to: "projects#delete_project"

      get 'add_subscribers', to: 'subscribers#add_subscribers'
      put 'add_subscriber', to: 'subscribers#add_subscriber'
      delete 'remove_subscriber', to: 'subscribers#remove_subscriber'
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

  devise_for :users, :path => 'u', controllers: {
            registrations: 'users/registrations'
  }

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
