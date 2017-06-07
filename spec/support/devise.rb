# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) { Devise.g5_strict_token_validation = false }

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  # We're only adding the integration test helpers to request specs
  # because the feature specs use the omniauth helpers instead
  config.include Devise::Test::IntegrationHelpers, type: :request
end
