MobileZen::Application.routes.draw do
  devise_for :users
  resources :text_messages, except: [:index, :show, :edit, :update]

  get 'about' => 'pages#about'
  post 'registration' => 'text_messages#registration'
  
  root to: 'text_messages#new'
end
