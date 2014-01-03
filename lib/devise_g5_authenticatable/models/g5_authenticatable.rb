module Devise
  module Models
    module G5Authenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :email
        attr_accessible :email
      end
    end
  end
end
