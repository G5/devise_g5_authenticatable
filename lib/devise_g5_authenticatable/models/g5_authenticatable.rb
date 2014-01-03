module Devise
  module Models
    module G5Authenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :password
        attr_accessible :email, :password
      end
    end
  end
end
