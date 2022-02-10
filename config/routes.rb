Rails.application.routes.draw do
  resources :waitlists
  resources :enrollments
  resources :courses
  resources :admins
  resources :instructors
  resources :students
  resources :users
  resources :sessions, only: %i[new create destroy]
  root 'home#index'

  get 'student_signup', to: "students#new", as: 'student_signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get '/students/:id', to: 'students#show', as: 'show_student'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
