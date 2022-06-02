Rails.application.routes.draw do
  resources :contacts
  root 'statics#top'
  get :dashboard, to: 'teams#dashboard'
  get :owner_change, to: 'teams#owner_change'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  resource :user

  resources :teams do
    resources :assigns, only: %w(create destroy)
    resources :agendas, shallow: true do
      resources :articles do
        resources :comments
      end
    end
    member do
      post :owner_change
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
