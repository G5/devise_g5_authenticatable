source 'https://rubygems.org'

# Specify your gem's dependencies in devise_g5_authenticatable.gemspec
gemspec

# Dependencies for the dummy test app
gem 'rails', '4.1.4'
gem 'jquery-rails'
gem 'pg'
gem 'protected_attributes'

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
