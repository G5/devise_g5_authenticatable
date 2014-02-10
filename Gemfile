source 'https://rubygems.org'
source "https://#{ENV['GEMFURY_TOKEN']}@gem.fury.io/me/"

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'rails', '~> 3.2.15'
gem 'jquery-rails'
gem 'pg'

group :test, :development do
  gem 'rspec-rails', '~> 2.14'
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'simplecov'
  gem 'codeclimate-test-reporter'
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '~> 4.3', require: false
end
