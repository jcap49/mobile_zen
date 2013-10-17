MobileZen::Application.routes.draw do
  devise_for :users
  resources :text_messages, except: [:index, :show, :edit, :update]

  get 'about' => 'pages#about'
  post 'process_text_message' => 'text_messages#process_text_message'
  
  root to: 'pages#index'

end
