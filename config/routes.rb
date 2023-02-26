Rails.application.routes.draw do
  #Initial redirect to login
  root :to => redirect('/login')
  #Route to fetch moves
  get'search',to: "movements#search"
  # Defines the root path route ("/")
  resources :movements
  resources :accounts
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'password_reset',
    registration: 'signup'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
