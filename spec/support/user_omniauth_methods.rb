# frozen_string_literal: true

module UserOmniauthMethods
  def stub_g5_omniauth(user, options = {})
    OmniAuth.config.mock_auth[:g5] = OmniAuth::AuthHash.new({
      uid: user.uid,
      provider: 'g5',
      info: { email: user.email },
      credentials: { token: user.g5_access_token },
      extra: {
        raw_info: {
          accessible_applications: ['global'],
          restricted_application_redirect_url: 'https://imc.com'
        }
      }
    }.merge(options))
  end

  def stub_g5_invalid_credentials
    OmniAuth.config.mock_auth[:g5] = :invalid_credentials
  end

  def visit_path_and_login_with(path, user)
    stub_g5_omniauth(user)
    visit path
  end
end

RSpec.configure do |config|
  config.before(:all) { OmniAuth.config.logger = Logger.new('/dev/null') }

  config.before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:g5] = nil
  end
  config.after(:each) { OmniAuth.config.test_mode = false }

  config.include UserOmniauthMethods, type: :feature
end
