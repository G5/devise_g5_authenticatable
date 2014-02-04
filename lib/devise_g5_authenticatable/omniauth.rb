require 'devise/omniauth'
require 'omniauth-g5'

OmniAuth.config.on_failure do |env|
  env['devise.mapping'] = Devise::Mapping.find_by_path!(env['PATH_INFO'], :path)
  controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:sessions])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end
