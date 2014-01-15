module Devise
  class G5SessionsController < Devise::OmniauthCallbacksController
    def new
      redirect_to user_g5_authorize_path
    end

    def create
      self.resource = resource_class.find_and_update_for_g5_oauth(auth_data)

      if resource.present?
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in_and_redirect(resource)
      else
        set_flash_message(:error, :not_found) if is_navigational_format?
        redirect_to(new_registration_path(resource_name))
      end
    end

    protected
    def auth_data
      @auth_data ||= request.env['omniauth.auth']
    end
  end
end
