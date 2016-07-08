Rails.application.routes.draw do
  resources :apps, only: [ :index ]
end
