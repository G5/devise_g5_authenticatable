# frozen_string_literal: true

unless defined?(ActionController::StrongParameters)
  require 'devise_g5_authenticatable/models/protected_attributes'
end
