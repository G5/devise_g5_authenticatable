# frozen_string_literal: true

Warden::Manager.after_set_user only: :fetch do |record, warden, options|
  if Devise.g5_strict_token_validation
    scope = options[:scope]

    auth_client = G5AuthenticationClient::Client.new(
      allow_password_credentials: 'false',
      access_token: record.g5_access_token
    )

    begin
      auth_client.token_info
    rescue StandardError
      proxy = Devise::Hooks::Proxy.new(warden)
      proxy.sign_out(record)
      record.revoke_g5_credentials!
      throw :warden, scope: scope
    end
  end
end
