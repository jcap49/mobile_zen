MobileZen::Application.routes.draw do
  devise_for :users
  resources :text_messages, except: [:index, :show, :edit, :update]

  get 'about' => 'pages#about'
  
  root to: 'text_messages#new'
end
