require 'g5_authentication_client'

module Devise
  module G5
    class AuthUserCreator
      attr_reader :model

      def initialize(authenticatable_model)
        @model = authenticatable_model
      end

      def create
        create_auth_user unless auth_user_exists?
      end

      private
      def create_auth_user
        auth_user = auth_client.create_user(auth_user_args)
        set_auth_attributes(auth_user)
        auth_user
      end

      def auth_user_exists?
        !model.uid.blank?
      end

      def auth_client
        G5AuthenticationClient::Client.new(access_token: updated_by.g5_access_token)
      end

      def updated_by
        model.updated_by || model
      end

      def auth_user_args
        {email: model.email,
         password: model.password,
         password_confirmation: model.password_confirmation}
      end

      def set_auth_attributes(auth_user)
        model.provider = 'g5'
        model.uid = auth_user.id
        model.clean_up_passwords
      end
    end
  end
end
