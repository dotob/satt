Satt::Application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  root :to => 'home#index'

  resources :master_orders
  match 'choose_menu' => 'master_orders#choose_menu'
  match 'close_master_order' => 'master_orders#close_master_order'
  match 'toggle_paid_of_userorder' => 'master_orders#toggle_paid_of_userorder'
  match 'mail_users_lunch_arrived' => 'master_orders#mail_users_lunch_arrived'

  resources :user_orders
  match 'add_orderitem/:user_order_id/:menu_item_id' => 'user_orders#add_orderitem', :as => :add_orderitem
  match 'remove_orderitem' => 'user_orders#remove_orderitem'
  match 'add_specialwishes' => 'user_orders#add_specialwishes'
  match 'search_menu_items/:user_order_id/:searchterm' => 'user_orders#search_menu_items'
  match 'search_menu_items/:user_order_id' => 'user_orders#search_menu_items'

  resources :menu_items
  match 'menu_items_for_menu/:id' => 'menu_items#menu_items_for_menu', :as => :menu_items_for_menu
  
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
