module DeviseG5Authenticatable
  module Models
    module ProtectedAttributes
      extend ActiveSupport::Concern

      included do
        attr_accessible :email, :password, :password_confirmation,
                        :current_password, :provider, :uid, :updated_by
      end
    end
  end
end

module Devise::Models::G5Authenticatable
  include DeviseG5Authenticatable::Models::ProtectedAttributes
end
