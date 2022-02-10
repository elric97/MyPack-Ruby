Rails.application.routes.draw do
  resources :waitlists
  resources :enrollments
  resources :courses
  resources :admins
  resources :instructors
  resources :students
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
