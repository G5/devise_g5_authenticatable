RSpec.configure do |config|
  config.before(:all) { OmniAuth.config.logger = Logger.new('/dev/null') }
end
