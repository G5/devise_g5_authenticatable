module DeviseG5Authenticatable
  module Helpers
    protected
    def clear_blank_passwords
      Devise.mappings.keys.each do |scope|
        if params[scope].present?
          password_params(scope).each { |p| clear_blank_param(scope, p) }
        end
      end
    end

    def password_params(scope)
      params[scope].keys.select { |k| k =~ /password/ }
    end

    def clear_blank_param(scope, param_name)
      params[scope].delete(param_name) if params[scope][param_name].blank?
    end
  end
end
