Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'home/about' => "homes#about"
  resources :books, except: [:new] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, except: [:new, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end
  get "search" => "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
