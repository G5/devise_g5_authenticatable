require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserCreator
      def create(user)
        create_auth_user(user) unless auth_user_exists?(user)
      end

      private
      def create_auth_user(user)
        auth_user = client(user).create_user(auth_user_args(user))
        set_auth_attributes(user, auth_user)
        auth_user
      end

      def auth_user_exists?(user)
        !(user.uid.nil? || user.uid.empty?)
      end

      def client(user)
        updated_by = user.updated_by || user
        G5AuthenticationClient::Client.new(access_token: updated_by.g5_access_token)
      end

      def auth_user_args(user)
        {email: user.email,
         password: user.password,
         password_confirmation: user.password_confirmation}
      end

      def set_auth_attributes(model, auth_user)
        model.provider = 'g5'
        model.uid = auth_user.id
        model.clean_up_passwords
      end
    end
  end
end
