Whitekit::Application.routes.draw do

  controller 'whitekit::general' do
    post 'whitekit/make_aliases' => :make_aliases, as: 'whitekit_make_aliases'
    post 'whitekit/clear_caches' => :clear_caches, as: 'whitekit_clear_caches'
    post 'whitekit/create_component' => :create_component, as: 'whitekit_create_component'
    post 'whitekit/get_component_params' => :get_component_params, as: 'whitekit_get_component_params'
    post 'whitekit/get_file_content' => :get_file_content, as: 'whitekit_get_file_content'
    post 'whitekit/get_folder_content' => :get_folder_content, as: 'whitekit_get_folder_content'
    post 'whitekit/save_file_content' => :save_file_content, as: 'whitekit_save_file_content'
    post 'whitekit/session_path' => :session_path, as: 'whitekit_session_path'
    post 'whitekit/db_backup' => :db_backup, as: 'whitekit_db_backup'
    post 'whitekit/db_recovery' => :db_recovery, as: 'whitekit_db_recovery'
  end

  mount Ckeditor::Engine => '/ckeditor'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  # Need for Whitekit News
  #resources :news, only: [:index, :show] do
  #  get 'page/:page', action: :index, on: :collection
  #end

  # Place your routes here




  root :to => 'pages#index'
  get '*alias' => 'pages#index', as: 'page'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
