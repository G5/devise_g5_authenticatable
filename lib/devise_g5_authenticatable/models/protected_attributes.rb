# frozen_string_literal: true

module DeviseG5Authenticatable
  module Models
    # Support protected attributes for users in apps that require it
    module ProtectedAttributes
      extend ActiveSupport::Concern

      included do
        attr_accessible :email, :password, :password_confirmation,
                        :current_password, :provider, :uid, :updated_by
      end
    end
  end
end

module Devise
  module Models
    # If this file is required, then protected attributes will be automatically
    # mixed in to the g5 authenticatable model(s)
    module G5Authenticatable
      include DeviseG5Authenticatable::Models::ProtectedAttributes
    end
  end
end
