Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	
	root "users#home"
	get 'profile', to: 'users#profile'
	patch 'profile/edit_account', to: 'users#edit_account'

	resources :users
	resources :posts
	resources :comments
	resources :friendships

end