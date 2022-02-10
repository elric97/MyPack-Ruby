class HomeController < ApplicationController
  skip_before_action :authorized, only: [:index]
  skip_before_action :role_assigned, only: [:index]
  def index
  end
end
