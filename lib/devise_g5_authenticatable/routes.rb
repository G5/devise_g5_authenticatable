module Devise
  class Mapping
    alias :original_initialize :initialize

    def initialize(name, options)
      set_default_g5_controllers(options)
      original_initialize(name, options)
    end

    private
    def set_default_g5_controllers(options)
      options[:controllers] ||= {}
      options[:controllers].reverse_merge!({
        registrations: 'devise_g5_authenticatable/registrations'
      })
      options
    end
  end
end

module ActionDispatch::Routing
  class Mapper
    protected
    def devise_session(mapping, controllers)
      set_omniauth_path_prefix(mapping)
      build_session_routes(mapping, controllers)
      build_g5_omniauth_routes(mapping, controllers)
    end

    def set_omniauth_path_prefix(mapping)
      path_prefix = Devise.omniauth_path_prefix || "/#{mapping.fullpath}/auth".squeeze("/")
      set_omniauth_path_prefix!(path_prefix) unless ::OmniAuth.config.path_prefix.present?
    end

    def build_session_routes(mapping, controllers)
      resource :session, only: [], controller: controllers[:sessions], path: '' do
        get   :new,     path: mapping.path_names[:sign_in], as: :new
        post  :create,  path: mapping.path_names[:sign_in]
        match :destroy, path: mapping.path_names[:sign_out], as: :destroy, via: mapping.sign_out_via
      end
    end

    def build_g5_omniauth_routes(mapping, controllers)
      match 'auth/g5',
        controller: controllers[:sessions],
        action: 'omniauth_passthru',
        as: :g5_authorize,
        via: [:get, :post]

      match 'auth/g5/callback',
        controller: controllers[:sessions],
        action: 'create',
        as: :g5_callback,
        via: [:get, :post]
    end
  end
end
