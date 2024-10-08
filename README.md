Rails.application.routes.draw do
  devise_for :users
  resources :tasks do
    member do
      get :show_comments
    end
    resources :comments, only: [:create, :destroy]
  end

  root 'tasks#index'
end
