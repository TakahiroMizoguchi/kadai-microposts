Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # ユーザの新規登録URLを /signupにするための設定。
  get 'signup', to: 'users#new'
  
  resources :users, only: [:index, :show, :new, :create] do
    # 中間テーブル関連のルーティング。フォロー中のユーザとフォローされているユーザ、お気に入り登録しているユーザの一覧を表示。
    member do 
      get :followings
      get :followers
      get :likes
    end
  end

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
end