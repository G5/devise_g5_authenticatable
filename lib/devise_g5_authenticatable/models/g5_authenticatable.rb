require 'devise_g5_authenticatable/g5'
require 'devise_g5_authenticatable/hooks/g5_authenticatable'

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

        before_save :auth_user
      end

      def auth_user
        begin
          if new_record?
            G5::AuthUserCreator.new(self).create
          else
            G5::AuthUserUpdater.new(self).update
          end
        rescue OAuth2::Error => e
          logger.error("Couldn't save user credentials because: #{e}")
          raise ActiveRecord::RecordNotSaved.new(e.code)
        rescue StandardError => e
          logger.error("Couldn't save user credentials because: #{e}")
          raise ActiveRecord::RecordNotSaved.new(e.message)
        end
      end

      def clean_up_passwords
        self.password = self.password_confirmation = self.current_password = nil
      end

      def valid_password?(password_to_check)
        validator = Devise::G5::AuthPasswordValidator.new(self)
        validator.valid_password?(password_to_check)
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

        valid
      end

      def update_g5_credentials(oauth_data)
        self.g5_access_token = oauth_data.credentials.token
      end

      def revoke_g5_credentials!
        self.g5_access_token = nil
        save!
      end

      module ClassMethods
        def find_for_g5_oauth(oauth_data)
          found_user = find_by_provider_and_uid(oauth_data.provider.to_s, oauth_data.uid.to_s)
          return found_user if found_user.present?
          find_by_email_and_provider(oauth_data.info.email, oauth_data.provider.to_s)
        end

        def find_and_update_for_g5_oauth(oauth_data)
          resource = find_for_g5_oauth(oauth_data)
          if resource
            resource.update_g5_credentials(oauth_data)
            resource.save!
          end
          resource
        end

        def new_with_session(params, session)
          defaults = ActiveSupport::HashWithIndifferentAccess.new
          if auth_data = session && session['omniauth.auth']
            defaults[:email] = auth_data.info.email
            defaults[:provider] = auth_data.provider
            defaults[:uid] = auth_data.uid
          end

          new(defaults.merge(params))
        end
      end
    end
  end
end
