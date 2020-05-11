Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    delete :delete_file_attachment, on: :member
    resources :answers, shallow: true, only: [:edit, :create, :update, :destroy] do
      delete :delete_file_attachment, on: :member
      patch :mark_as_best, on: :member
    end
  end

  root to: 'questions#index'
end
