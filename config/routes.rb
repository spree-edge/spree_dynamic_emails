# frozen_string_literal: true

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :email_templates do
      member do
        post :test_mail
      end
    end
    resources :campaigns do
      member do
        post :send_mail
      end
      member do
        get :campaign_log
      end
      member do
        post :delete_jobs
      end
    end
  end
end
