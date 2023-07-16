Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  controller :send_stream do
    get :broken
    get :working_simulating_partial_write
    get :working_with_partial_write
    get :working_with_full_write
  end
end
