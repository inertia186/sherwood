Rails.application.routes.draw do
  root to: 'static#default_project'
  
  resources :users, only: %w(new create)
  get 'sign_up' => 'users#new', as: :sign_up

  resources :projects do
    member do
      get :card
    end
    resources :posts
    resources :public_posts, only: :index
    resources :authors
  end
  
  resources :posts do
    member do
      get :card
      post :check_for_plagiarism
    end
  end

  resources :public_posts, only: :index

  resource :account, only: %w(edit update destroy)
  resource :session, only: %w(new create destroy)
  get 'log_in' => 'sessions#new', as: :log_in
  get 'log_out' => 'sessions#destroy', as: :log_out

  get 'dashboard' => 'static#dashboard', as: :dashboard
  get 'faq' => 'static#faq', as: :faq
end
