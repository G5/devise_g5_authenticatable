module DeviseG5Authenticatable
  module ScopedViews
    extend ActiveSupport::Concern

    protected

    def render_with_scope(action, path="devise/#{controller_name}")
      super
    end
  end
end
