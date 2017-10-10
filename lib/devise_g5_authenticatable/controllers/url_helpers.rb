# frozen_string_literal: true

module DeviseG5Authenticatable
  # Routing helpers for G5 omniuath routes
  module UrlHelpers
    def g5_authorize_path(resource_or_scope, *args)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      _devise_route_context.send("#{scope}_g5_authorize_path", *args)
    end

    def g5_callback_path(resource_or_scope, *args)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      _devise_route_context.send("#{scope}_g5_callback_path", *args)
    end

    private

    define_method(:_devise_route_context) do
      @_devise_route_context ||= send(:main_app)
    end unless method_defined?(:_devise_route_context)
  end
end
