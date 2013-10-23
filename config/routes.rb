MobileZen::Application.routes.draw do
  devise_for :users
  devise_scope :user do 
    post 'register_user' => 'custom_users#create'
  end

  resources :text_messages, except: [:index, :show, :edit, :update]

  get 'about' => 'pages#about'
  post 'process_text_message' => 'text_messages#process_text_message'

  root to: 'pages#index'

end
