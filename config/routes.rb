Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}

  get 'user/index'
  post 'user/send_credits' => 'user#send_credits'

  #API
  get '/api/v1/users/current' => 'user#current'
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
