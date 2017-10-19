# frozen_string_literal: true

module Devise
  # Add custom G5 controllers to default routing options
  class Mapping
    alias original_initialize initialize

    def initialize(name, options)
      setup_default_g5_controllers(options)
      original_initialize(name, options)
    end

    private

    def setup_default_g5_controllers(options)
      options[:controllers] ||= {}
      options[:controllers].reverse_merge!(
        registrations: 'devise_g5_authenticatable/registrations',
        sessions: 'devise_g5_authenticatable/sessions'
      )
      options
    end
  end
end

module ActionDispatch
  module Routing
    # Add G5 omniauth callbacks to set of routes
    class Mapper
      protected

      def devise_session(mapping, controllers)
        setup_omniauth_path_prefix(mapping)
        build_session_routes(mapping, controllers)
        build_g5_omniauth_routes(mapping, controllers)
      end

      def setup_omniauth_path_prefix(mapping)
        return if ::OmniAuth.config.path_prefix.present?
        path_prefix = Devise.omniauth_path_prefix ||
                      "/#{mapping.fullpath}/auth".squeeze('/')
        set_omniauth_path_prefix!(path_prefix)
      end

      def build_session_routes(mapping, controllers)
        resource(:session, only: [],
                           controller: controllers[:sessions],
                           path: '') do
          get   :new,     path: mapping.path_names[:sign_in],
                          as: :new
          post  :create,  path: mapping.path_names[:sign_in]
          match :destroy, path: mapping.path_names[:sign_out],
                          as: :destroy,
                          via: mapping.sign_out_via
        end
      end

      def build_g5_omniauth_routes(_mapping, controllers)
        match 'auth/g5', controller: controllers[:sessions],
                         action: 'omniauth_passthru',
                         as: :g5_authorize,
                         via: %i[get post]

        match 'auth/g5/callback', controller: controllers[:sessions],
                                  action: 'create',
                                  as: :g5_callback,
                                  via: %i[get post]
      end
    end
  end
end
