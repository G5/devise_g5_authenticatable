class HomeController < ApplicationController
  set_callback :process_action, :before, :authenticate_user!,
               only: [:protected_action]

  def index
  end

  def protected_action
  end
end
