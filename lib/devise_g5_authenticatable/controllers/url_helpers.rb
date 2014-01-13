module DeviseG5Authenticatable
  module UrlHelpers
    def g5_authorize_path(resource_or_scope)
      user_g5_authorize_path
    end

    def g5_callback_path(resource_or_scope)
      user_g5_callback_path
    end

    def user_g5_authorize_path
      '/users/auth/g5'
    end

    def user_g5_callback_path
      '/users/auth/g5/callback'
    end
  end
end
