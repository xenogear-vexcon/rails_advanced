Rails.application.routes.draw do
  devise_for :users

  resources :files, only: [:destroy]

  resources :questions do
    resources :answers, shallow: true, only: [:edit, :create, :update, :destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :users do
    resources :rewards, only: [:index]
  end

  root to: 'questions#index'
end
