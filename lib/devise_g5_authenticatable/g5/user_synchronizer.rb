module G5
  class UserSynchronizer
    def initialize(options={})
      [:endpoint, :client_id, :client_secret,
       :username, :password].each do |opt|
        instance_variable_set("@#{opt}", options[opt])
      end
    end

    def sync_uids
      begin
        User.skip_callback(:save, :before, :auth_user)

        User.all.each do |user|
          auth_user = auth_client.find_user_by_email(user.email)
          update_user_from_auth(user, auth_user)
          user.save!
        end
      ensure
        User.set_callback(:save, :before, :auth_user)
      end
    end

    def auth_client
      @auth_client ||= G5AuthenticationClient::Client.new(
        endpoint: @endpoint,
        client_id: @client_id,
        client_secret: @client_secret,
        username: @username,
        password: @password,
        allow_password_credentials: true
      )
    end

    private
    def update_user_from_auth(local_user, auth_user)
      if auth_user
        local_user.uid = auth_user.id
        local_user.provider = 'g5'
      else
        local_user.uid = nil
        local_user.provider = nil
      end
    end
  end
end
