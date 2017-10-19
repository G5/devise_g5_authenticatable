# frozen_string_literal: true

module DeviseG5Authenticatable
  # Registrations controller with custom error handling
  class RegistrationsController < Devise::RegistrationsController
    rescue_from ActiveRecord::RecordNotSaved, with: :handle_resource_error
  end
end
