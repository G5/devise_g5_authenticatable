RSpec.configure do |config|
  config.before(:each) { Devise.g5_strict_token_validation = false }
  config.include Devise::TestHelpers, type: :controller
end
