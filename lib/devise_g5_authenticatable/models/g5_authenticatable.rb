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

      def update_roles_from_auth(auth_data)
      end

      module ClassMethods
        def find_for_g5_oauth(oauth_data)
          found_user = find_by_provider_and_uid(oauth_data.provider.to_s, oauth_data.uid.to_s)
          return found_user if found_user.present?
          find_by_email_and_provider(oauth_data.info.email, oauth_data.provider.to_s)
        end

        def find_and_update_for_g5_oauth(auth_data)
          resource = find_for_g5_oauth(auth_data)
          if resource
            resource.assign_attributes(auth_attributes(auth_data))
            resource.update_g5_credentials(auth_data)
            resource.update_roles_from_auth(auth_data)
            without_auth_callback { resource.save! }
          end
          resource
        end

        def new_with_session(params, session)
          new_attributes = params

          auth_data = session && session['omniauth.auth']

          if auth_data.present?
            new_attributes = new_attributes.reverse_merge(auth_attributes(auth_data))
          end

          resource = new(new_attributes)
          resource.update_roles_from_auth(auth_data) if auth_data.present?
          resource
        end

        def auth_attributes(auth_data)
          {
            uid: auth_data.uid,
            provider: auth_data.provider,
            email: auth_data.info.email
          }.with_indifferent_access
        end

        private
        def without_auth_callback
          skip_callback :save, :before, :auth_user
          yield
          set_callback :save, :before, :auth_user
        end
      end
    end
  end
end
