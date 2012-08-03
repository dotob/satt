Satt::Application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  root :to => 'home#index'
  match 'create_master_order' => 'home#create_master_order'
  match 'add_orderitem' => 'home#add_orderitem'
  match 'show_user_order' => 'home#show_user_order'
  match 'remove_orderitem' => 'home#remove_orderitem'
  match 'add_specialwishes' => 'home#add_specialwishes'
  match 'choose_masterorder/:id' => 'home#choose_masterorder'
  match 'show_userorders_of_masterorder' => 'home#show_userorders_of_masterorder'
  match 'toggle_paid_of_userorder' => 'home#toggle_paid_of_userorder'
  match 'close_master_order' => 'home#close_master_order'
  match 'sort_order_items' => 'home#sort_order_items'

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
