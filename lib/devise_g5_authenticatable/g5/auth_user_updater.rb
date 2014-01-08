require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserUpdater
      attr_reader :model

      def initialize(authenticatable_model)
        @model = authenticatable_model
      end

      def update
        update_auth_user if credentials_changed?
      end

      private
      def update_auth_user
        auth_user = auth_client.update_user(auth_user_args)
        model.clean_up_passwords
        auth_user
      end

      def credentials_changed?
        model.email_changed? || !model.password.blank?
      end

      def auth_client
        G5AuthenticationClient::Client.new(access_token: updated_by.g5_access_token)
      end

      def updated_by
        model.updated_by || model
      end

      def auth_user_args
        {id: model.uid,
         email: model.email,
         password: model.password,
         password_confirmation: model.password_confirmation}
      end
    end
  end
end
