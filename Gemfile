# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'jquery-rails'
gem 'pg', '0.18'

# See the Appraisals file for all supported rails versions
gem 'rails', '~> 3.2.22'
gem 'devise', '~> 2.2'

# Bundler won't respect required_ruby_version without a ruby
# directive in the Gemfile, which breaks our build matrix
gem 'rake', '< 12.3', platforms: [:ruby_19]
gem 'public_suffix', '~> 1.4.0', platforms: [:ruby_19, :ruby_20]
gem 'nokogiri', '~> 1.6.0', platforms: [:ruby_19, :ruby_20, :ruby_21]

group :test, :development do
  gem 'appraisal'
  gem 'pry'
  gem 'pry-byebug', platforms: [:ruby_20, :ruby_21, :ruby_22,
                                :ruby_23, :ruby_24, :ruby_25]
  gem 'rspec-rails', '~> 3.6'
  gem 'test-unit', '~> 3.0' # required for ruby >= 2.2
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.8', require: false
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webmock', '~> 2.0' # for ruby 1.9.3 compatibility
end
