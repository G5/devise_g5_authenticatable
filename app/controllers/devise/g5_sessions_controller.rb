module Devise
  class G5SessionsController < Devise::OmniauthCallbacksController
    def new
      redirect_to user_g5_authorize_path
    end
  end
end
