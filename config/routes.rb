Rails.application.routes.draw do
  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/home', to: 'users#show' # test

  get '/create_session', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  delete '/posts/:id/comments', to: 'comments#destroy'
  post '/posts/:post_id/comments/:id', to: 'comments#update'
  get '/posts/:post_id/comments/:id', to: 'comments#show'

  post '/friend_request/delete', to: 'friend_requests#delete'
  post '/friend_request/new', to: 'friend_requests#create'
  post '/friendships/new', to: 'friendships#create'

  resources :friend_requests
  resources :users, :friendships
  resources :posts do
    resources :comments
  end

  get 'auth/developer', as: 'developer_auth'
  get 'auth/github', as: 'github_auth'
  match 'auth/:provider/callback' => 'sessions#create', via: [:get, :post]

  root 'users#new'
end
