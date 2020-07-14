Rails.application.routes.draw do

  root to: 'questions#index'

  devise_for :users

  resources :files, only: [:destroy]

  concern :rankable do
    member do
      patch :up
      patch :down
    end
  end

  resources :questions, concerns: :rankable do
    resources :comments, only: [:create, :edit, :update, :destroy]
    resources :answers, only: [:edit, :create, :update, :destroy], shallow: true do
      concerns :rankable
      patch :mark_as_best, on: :member
      resources :comments, only: [:create, :edit, :update, :destroy], shallow: false
    end
  end

  resources :users do
    resources :rewards, only: [:index]
  end

end
