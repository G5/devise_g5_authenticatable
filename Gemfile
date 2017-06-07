# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'jquery-rails'
gem 'pg'

# See the Appraisals file for all supported rails versions
gem 'rails', '~> 5.0.3'

group :test, :development do
  gem 'appraisal'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.6'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter'
  gem 'factory_girl_rails', '~> 4.8', require: false
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov'
  gem 'webmock'
end
