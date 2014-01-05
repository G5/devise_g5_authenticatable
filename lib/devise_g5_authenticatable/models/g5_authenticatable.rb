require 'devise_g5_authenticatable/g5/auth_user_updater'
require 'devise_g5_authenticatable/g5/auth_password_validator'

module Devise
  module Models
    # Authenticatable module, responsible for remote credential management
    # in G5 Auth.
    #
    # The module assumes that the following attributes have already been defined
    # on the model:
    #   * `provider`: the value will always be 'g5' for G5 Auth users
    #   * `uid`: the unique id for this user in G5 Auth
    #   * `g5_access_token`: the current OAuth access token, if one exists
    module G5Authenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :password, :password_confirmation, :current_password,
                      :updated_by
        attr_accessible :email, :password, :password_confirmation,
                        :current_password, :provider, :uid, :updated_by
      end

      def clean_up_passwords
        self.password = self.password_confirmation = self.current_password = nil
      end

      def valid_password?(password_to_check)
        Devise::G5::AuthPasswordValidator.new.valid_password?(self, password_to_check)
      end
    end
  end
end
