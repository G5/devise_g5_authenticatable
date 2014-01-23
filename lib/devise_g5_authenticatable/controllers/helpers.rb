module DeviseG5Authenticatable
  module Helpers
    extend ActiveSupport::Concern

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

    module ClassMethods
      def define_helpers(mapping)
        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def set_updated_by_#{mapping}
            resource_params = params[:#{mapping}] || params
            resource_params[:updated_by] = current_#{mapping}
          end
        METHODS
      end
    end
  end
end
