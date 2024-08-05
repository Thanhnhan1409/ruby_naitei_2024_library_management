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
      get "requests/show", to: "requests#show", as: "requests_show"
      get "borrowed_books", to: "borrow_books#index", as: :borrowed_books
      resources :requests, only: %i(index show update) do
        member do
          patch :update
        end
      end
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
      resources :authors
      resources :books, only: %i(index new create destroy edit update) do
        collection do
          get "borrowed_books"
        end
      end
      resources :borrow_books do
        collection do
          patch :mark_as_returned
        end
      end
    end
    
    resources :requests, only: %i(new create show index update) do
      member do
        patch :update
      end
    end
  end
end
