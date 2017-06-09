# frozen_string_literal: true

require 'g5_authentication_client'

module Devise
  module G5
    # Validate a user's G5 Auth credentials
    class AuthPasswordValidator
      attr_reader :model

      def initialize(authenticatable_model)
        @model = authenticatable_model
      end

      def valid_password?(password)
        begin
          auth_user = auth_client(password).me
        rescue OAuth2::Error => error
          raise unless error.code == 'invalid_resource_owner'
        rescue RuntimeError => error
          raise unless error.message =~ /Insufficient credentials/
        end

        !auth_user.nil?
      end

      private

      def auth_client(password)
        G5AuthenticationClient::Client.new(username: model.email,
                                           password: password)
      end
    end
  end
end
