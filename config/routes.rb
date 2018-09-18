Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users
      post 'authenticate', to: 'authentication#authenticate'
      get 'current_user', to: 'users#current'
      post 'register', to: 'users#create'
      resource :followers
      get 'users/:user_id/followers', to: 'followers#show'
      get 'users/:user_id/followers/refresh', to: 'followers#create'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
