module DeviseG5Authenticatable
  class RegistrationsController < Devise::RegistrationsController
    rescue_from ActiveRecord::RecordNotSaved, with: :handle_resource_error
  end
end
