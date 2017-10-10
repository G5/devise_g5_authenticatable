# frozen_string_literal: true

module DeviseG5Authenticatable
  # Custom sessions controller to require sign-in through the G5 auth server
  class SessionsController < Devise::OmniauthCallbacksController
    # Using underlying ActiveSupport::Callbacks API for compatibility with
    # rails 3 (which does not support *_action callbacks) and
    # rails 5 (which does not support *_filter callbacks)
    set_callback :process_action, :before, :require_no_authentication,
                 only: [:new, :create],
                 prepend: true

    def new
      redirect_to g5_authorize_path(resource_name)
    end

    def omniauth_passthru
      render status: 404, plain: 'Authentication passthru.'
    end

    def create
      self.resource = resource_class.find_and_update_for_g5_oauth(auth_data)
      resource ? sign_in_resource : register_resource
    end

    def destroy
      signed_in_resource.try(:revoke_g5_credentials!)
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
      redirect_url = URI.join(request.base_url,
                              after_sign_out_path_for(resource_name))
      redirect_to auth_client.sign_out_url(redirect_url.to_s)
    end

    def auth_client
      G5AuthenticationClient::Client.new
    end

    def after_omniauth_failure_path_for(_scope)
      main_app.root_path
    end

    def translation_scope
      'devise.sessions'
    end
  end
end
