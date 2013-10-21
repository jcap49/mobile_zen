MobileZen::Application.routes.draw do
  devise_for :users
  devise_scope :user do 
    post 'register_user' => 'custom_users#create'
  end

  resources :text_messages, except: [:index, :show, :edit, :update]

  post 'sign_up' => 'custom_users#new'
  get 'about' => 'pages#about'
  post 'process_text_message' => 'text_messages#process_text_message'
  # post 'register_user' => 'custom_users#create'

  root to: 'pages#index'

end
