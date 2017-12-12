class HomeController < ApplicationController
  def index
  end

  def protected_action
    authenticate_user!
  end
end
