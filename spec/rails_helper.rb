# frozen_string_literal: true

require 'spec_helper'

# Load rails dummy application
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'
require 'shoulda-matchers'
require 'factory_girl_rails'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Checks for pending migration and applies them before tests are run
if ActiveRecord::Migration.respond_to?(:maintain_test_schema!) # rails 4+
  ActiveRecord::Migration.maintain_test_schema!
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # The integration tests can be run with:
  # rspec -t type:feature
  # config.filter_run_excluding type: 'feature'

  # Filter lines from Rails gems in backtraces
  # config.filter_rails_from_backtrace!

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace('gem name')

  config.after(:suite) { WebMock.disable! }
end
