require 'g5_authentication_client'

module Devise
  module G5
    class AuthPasswordValidator
      def valid_password?(user, password)
        begin
          auth_user = auth_client(user.email, password).me
        rescue OAuth2::Error => error
          raise unless error.code == 'invalid_resource_owner'
        rescue RuntimeError => error
          raise unless error.message =~ /Insufficient credentials/
        end

        !auth_user.nil?
      end

      private
      def auth_client(username, password)
        G5AuthenticationClient::Client.new(username: username, password: password)
      end
    end
  end
end
