Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "static_pages/home"
    get "requests/new", to: "requests#new", as: "new_request"
    root "static_pages#home"
    resources :book_series, only: %i(show)
    resources :accounts, only: %i(new create)
    resources :users, only: %i(new create index)
    resources :ratings, only: %i(create)
    resources :carts, only: %i(create destroy show)
    resources :authors, only: %i(show index)
    namespace :admin do
      root "users#index"
      resources :users, only: :index do
        member do
          post "due_reminder"
        end
      end
      resources :accounts do
        member do
          post "update_status"
        end
      end
      resources :books, only: %i(index new create destroy edit update)
      resources :authors
    end
    resources :requests, only: %i(new create show index update) do
      member do
        patch :update
      end
    end
    resources :books do
      resources :comments, only: %i(create index)
    end

  end
end
