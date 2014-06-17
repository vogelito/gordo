Gordo::Application.routes.draw do
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :orders, only: [:create, :destroy, :index] do
    get 'toggle_delivery', :on => :member
  end
  resources :food_items do
    get 'toggle_active', :on => :member
    collection do
      get 'active'
    end
  end
  resources :charges do
    collection do
      post 'charge'
    end
  end

  root  'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/how_its_work',    to: 'static_pages#how_its_work',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/cancellation', to: 'orders#cancellation', via: 'get'
  post '/forget_password_token', to: 'users#forget_password_token'
  match '/forget_password', to: 'users#forget_password', via: 'get'
  get '/new_password/:token', to: 'users#new_password', as: :reset_new_password

  resources :users do
    get 'waiting', :on => :member
    get 'check_delivered'
    get 'check_delivered_order', :on => :member
    post 'reset_password', :on => :member
  end
  # match '/forget_password', to: 'users#forget_password', via: 'post'
  # match '/receipt', to: 'orders#receipt', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
