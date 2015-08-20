module EnvHelpers
  def stub_env_var(name, value)
    stub_const('ENV', ENV.to_hash.merge(name => value))
  end
end

RSpec.configure do |config|
  config.include EnvHelpers
end
