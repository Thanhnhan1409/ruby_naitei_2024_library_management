Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "static_pages/home"
    get "requests/new", to: "requests#new", as: "new_request"
    root "static_pages#home"
    resources :books, only: %i(index show)
    resources :book_series, only: %i(show)
    resources :accounts, only: %i(new create)
    resources :users, only: %i(new create index)
    resources :ratings, only: %i(create)
    resources :carts, only: %i(create destroy show)
    namespace :admin do
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
    end
    resources :requests, only: %i(new create show)
  end
end
