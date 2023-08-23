class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV["ADMIN_USERNAME"], password: ENV["ADMIN_SECRET_KEY"]
  def show
    @products = Product.all
    @categories = Category.all
  end
end
