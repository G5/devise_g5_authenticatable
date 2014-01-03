module Devise
  module Models
    module G5Authenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :password, :password_confirmation
        attr_accessible :email, :password, :password_confirmation
      end
    end
  end
end
