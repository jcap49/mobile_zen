MobileZen::Application.routes.draw do
  resources :text_messages, except: [:index, :show, :edit, :update]

  root to: 'text_messages#new'
end
