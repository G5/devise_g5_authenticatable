# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'jquery-rails'
gem 'pg'
gem 'protected_attributes'
gem 'rails', '~> 4.1.16'

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
