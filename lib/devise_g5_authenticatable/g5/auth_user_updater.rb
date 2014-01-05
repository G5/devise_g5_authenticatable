require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserUpdater
      def update(user)
        updated_by_user = user.updated_by || user
        client(updated_by_user).update_user(auth_user_args(user))
      end

      private
      def client(user)
        G5AuthenticationClient::Client.new(access_token: user.g5_access_token)
      end

      def auth_user_args(user)
        {id: user.uid.to_i,
         email: user.email,
         password: user.password,
         password_confirmation: user.password_confirmation}
      end
    end
  end
end
