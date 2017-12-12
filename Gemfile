# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'jquery-rails'
gem 'pg'

# See the Appraisals file for all supported rails versions
gem 'rails', '~> 3.2.22'
gem 'devise', '~> 2.2'

group :test, :development do
  gem 'appraisal'
  gem 'pry'
  gem 'pry-byebug', platforms: [:ruby_20, :ruby_21, :ruby_22,
                                :ruby_23, :ruby_24, :ruby_25]
  gem 'rspec-rails', '~> 3.6'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.8', require: false
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webmock'
end
