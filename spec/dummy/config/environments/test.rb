# frozen_string_literal: true

Dummy::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  cache_header_value = 'public, max-age=3600'
  if config.respond_to?(:public_file_server=)
    config.public_file_server.enabled = true
    config.public_file_server.headers = {
      'Cache-Control' => cache_header_value
    }
  else
    config.static_cache_controller = cache_header_value

    if config.respond_to?(:serve_static_files=)
      config.serve_static_files = true
    else
      config.serve_static_assets = true
    end
  end

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  config.eager_load = false
end
