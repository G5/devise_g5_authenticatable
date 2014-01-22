module Devise
  class SessionsController < Devise::OmniauthCallbacksController
    prepend_before_filter :require_no_authentication, only: [:new, :create]

    def new
      redirect_to g5_authorize_path(resource_name)
    end

    def omniauth_passthru
      render status: 404, text: 'Authentication passthru.'
    end

    def create
      self.resource = resource_class.find_and_update_for_g5_oauth(auth_data)
      resource ? sign_in_resource : register_resource
    end

    def destroy
      signed_in_resource.revoke_g5_credentials!
      local_sign_out
      remote_sign_out
    end

    protected
    def auth_data
      @auth_data ||= request.env['omniauth.auth']
      session['omniauth.auth'] = @auth_data
    end

    def sign_in_resource
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in_and_redirect(resource)
    end

    def register_resource
      set_flash_message(:alert, :not_found) if is_navigational_format?
      redirect_to(new_registration_path(resource_name))
    end

    def local_sign_out
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    end

    def remote_sign_out
      redirect_url =  URI.join(request.base_url,
                               after_sign_out_path_for(resource_name))
      redirect_to auth_client.sign_out_url(redirect_url.to_s)
    end

    def auth_client
      G5AuthenticationClient::Client.new
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
  end
end
