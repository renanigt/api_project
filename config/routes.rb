require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :shortened_urls, only: [:create, :show], param: :token do
        get 'top/:number', action: :top, on: :collection
      end
    end
  end
end
