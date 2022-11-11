Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :email_templates do 
      member do 
        post :test_mail
      end
    end
  end
end
