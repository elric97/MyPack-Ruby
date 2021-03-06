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
  get '/my_courses', to: 'enrollments#show_student_enrollments', as: 'show_enrollments'
  get '/my_waitlisted_courses', to: 'waitlists#show_student_waitlists', as: 'show_waitlists'
  get '/assign_roles', to: 'users#assign_new_roles', as: 'assign_roles'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
