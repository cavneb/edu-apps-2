EduApps::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :api_keys, except: [:new, :edit, :update]

      # get 'users/:user_id/memberships' => 'memberships#index'
      # get 'organizations/:organization_id/memberships' => 'memberships#index'

      resources :users, except: [:new, :edit] do
        collection do
          put 'update_password'
        end
      end

      resources :memberships, only: [:index, :show, :destroy] do
        collection do
          post 'create_organization'
        end
      end

      resources :organizations, except: [:new, :edit] do
        member do
          post 'add_member'
        end
      end

      resources :lti_apps, path: '/apps', only: [:index, :show] do
        resources :reviews
      end

      resources :reviews
      
      resources :tags, only: [:index, :show]

      post 'session' => 'session#create'
    end
  end
end