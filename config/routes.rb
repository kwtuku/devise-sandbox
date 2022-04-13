Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'home#index'
  resources :users, only: %i[index]
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
