GoodLock::Application.routes.draw do
  root 'home#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: %i(new destroy)
  resource :user, only: %i(show), format: 'json'
end
