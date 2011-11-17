Gel::Application.routes.draw do

  root to: 'projects#index'

  resources :projects do
    member do
      post :refresh
    end

    resources :branches, :only => :deploy do
      member do
        post :deploy
      end
    end
  end

end
