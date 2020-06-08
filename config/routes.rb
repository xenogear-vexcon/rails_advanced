Rails.application.routes.draw do
  devise_for :users

  resources :files, only: [:destroy]

  concern :rankable do
    member do
      patch :up
      patch :down
    end
  end

  resources :questions do
    concerns :rankable
    resources :answers, shallow: true, only: [:edit, :create, :update, :destroy] do
      concerns :rankable
      patch :mark_as_best, on: :member
    end
  end

  resources :users do
    resources :rewards, only: [:index]
  end

  root to: 'questions#index'
end
