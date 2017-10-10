# frozen_string_literal: true

module Devise
  module TestHelpers
    # Support devise 4 syntax under earlier versions
    module Compatibility
      extend ActiveSupport::Concern

      included do
        alias_method :old_sign_in, :sign_in

        define_method(:sign_in) do |model, options|
          old_sign_in(options[:scope], model)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.before(:each) { Devise.g5_strict_token_validation = false }

  if defined?(Devise::Test) # devise 4
    config.include Devise::Test::ControllerHelpers, type: :controller
    config.include Devise::Test::ControllerHelpers, type: :view

    # We're only adding the integration test helpers to request specs
    # because the feature specs use the omniauth helpers instead
    config.include Devise::Test::IntegrationHelpers, type: :request
  else
    config.include Devise::TestHelpers, type: :controller
    config.include Devise::TestHelpers::Compatibility, type: :controller
  end
end
