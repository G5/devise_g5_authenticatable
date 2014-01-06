require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserCreator
      def create(user)
        update_by_user = user.updated_by || user
        client(update_by_user).create_user(auth_user_args(user))
      end

      private
      def client(user)
        G5AuthenticationClient::Client.new(access_token: user.g5_access_token)
      end

      def auth_user_args(user)
        {email: user.email,
         password: user.password,
         password_confirmation: user.password_confirmation}
      end
    end
  end
end
