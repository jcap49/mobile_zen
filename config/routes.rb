MobileZen::Application.routes.draw do
  resources :text_messages

  root to: 'text_messages#new'
end
