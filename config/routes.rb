Gel::Application.routes.draw do

  root to: 'projects#index'

  resources :projects do
    member do
      get :refresh
    end
  end

end
