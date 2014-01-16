module Devise
  class G5SessionsController < Devise::OmniauthCallbacksController
    def new
      redirect_to user_g5_authorize_path
    end

    def create
      self.resource = resource_class.find_and_update_for_g5_oauth(auth_data)

      if resource.present?
        sign_in_resource
      else
        register_resource
      end
    end

    def destroy
      signed_in_resource.revoke_g5_credentials!
      sign_out_resource
      redirect_to auth_client.sign_out_url(after_sign_out_redirect_url)
    end

    protected
    def auth_data
      @auth_data ||= request.env['omniauth.auth']
    end

    def sign_in_resource
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in_and_redirect(resource)
    end

    def register_resource
      set_flash_message(:error, :not_found) if is_navigational_format?
      redirect_to(new_registration_path(resource_name))
    end

    def sign_out_resource
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    end

    def after_sign_out_redirect_url
      "#{request.base_url}#{after_sign_out_path_for(resource_name)}"
    end

    def auth_client
      G5AuthenticationClient::Client.new
    end
  end
end
