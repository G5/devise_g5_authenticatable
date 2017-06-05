# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'jquery-rails'
gem 'pg'
gem 'protected_attributes'
gem 'rails', '4.1.4'
gem 'rake', '> 11.0.1', '< 12'

group :test, :development do
  gem 'pry-byebug'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails', '~> 2.14'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter'
  gem 'factory_girl_rails', '~> 4.3', require: false
  gem 'shoulda-matchers', '~> 2.6'
  gem 'simplecov'
  gem 'webmock'
end
