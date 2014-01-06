require 'devise_g5_authenticatable/g5'

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

        before_save :auth_user
      end

      def auth_user
        begin
          # TODO: more of this logic can be moved into
          # AuthUserCreator and AuthUserUpdater
          if new_record? && uid.nil?
            user=Devise::G5::AuthUserCreator.new.create(self)
            self.uid=user.id.to_s
            self.provider = 'g5'
          elsif !new_record? && email &&
                (email_changed? || !password.blank?)
            Devise::G5::AuthUserUpdater.new.update(self)
          end
        rescue OAuth2::Error => e
          logger.error("Couldn't save user credentials because: #{e}")
          raise ActiveRecord::RecordNotSaved.new(e.code)
        rescue StandardError => e
          logger.error("Couldn't save user credentials because: #{e}")
          raise ActiveRecord::RecordNotSaved.new(e.message)
        ensure
          clean_up_passwords
        end
      end

      def clean_up_passwords
        self.password = self.password_confirmation = self.current_password = nil
      end

      def valid_password?(password_to_check)
        Devise::G5::AuthPasswordValidator.new.valid_password?(self, password_to_check)
      end

      def update_with_password(params)
        updated_attributes = params.reject { |k,v| k =~ /password/ && v.blank? }
        current_password = updated_attributes.delete(:current_password)

        if valid = valid_password?(current_password)
          valid = update_attributes(updated_attributes)
        elsif current_password.blank?
          errors.add(:current_password, :blank)
        else
          errors.add(:current_password, :invalid)
        end

        clean_up_passwords

        valid
      end
    end
  end
end
