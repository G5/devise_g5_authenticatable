require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserUpdater
      def update(user)
        update_auth_user(user) if credentials_changed?(user)
      end

      private
      def update_auth_user(user)
        auth_user = client(user).update_user(auth_user_args(user))
        user.clean_up_passwords
        auth_user
      end

      def credentials_changed?(user)
        user.email_changed? || !user.password.blank?
      end

      def client(user)
        updated_by_user = user.updated_by || user
        G5AuthenticationClient::Client.new(access_token: updated_by_user.g5_access_token)
      end

      def auth_user_args(user)
        {id: user.uid,
         email: user.email,
         password: user.password,
         password_confirmation: user.password_confirmation}
      end
    end
  end
end
