Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :login, to: 'sessions#create'
          post :register, to: 'registrations#create'
          get :me, to: 'users#me'
          get '/:id', to: 'users#show'
        end
        member do
          put :me, to: 'users#update'
          get :sightings, to: 'users/sightings#index'
        end
      end
      get 'user/favourites', to: 'flowers/favourites#index'

      resources :sightings, except: [:edit, :new] do
        resources :images, only: [:index, :create, :destroy],
                           controller: 'sightings/images'
        resources :likes, only: [:index, :create],
                  controller: 'sightings/likes' do
        end
        delete 'likes', to: 'sightings/likes#destroy'
        resources :comments, only: [:index, :create, :destroy],
                  controller: 'sightings/comments'
      end

      resources :flowers, only: [:index, :show, :create] do
        collection do
          get :search, to: 'flowers#search'
        end
        resources :images, only: [:index]
        resource :favourite, only: [:create, :destroy], controller: 'flowers/favourites'
      end

    end
  end

  root 'welcome#index'
end
