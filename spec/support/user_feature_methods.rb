module UserFeatureMethods
  def visit_path_and_login_with(path, user)
    login_as user
    visit path
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.after(:each, type: :feature) { Warden.test_reset! }
  config.include UserFeatureMethods, type: :feature
end
