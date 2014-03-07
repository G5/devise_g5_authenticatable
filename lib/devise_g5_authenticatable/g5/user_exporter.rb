require 'g5_authentication_client'

module G5
  # Exports all users to the G5 auth server.
  # Assumes presence of User model with uid and
  # provider attributes.
  class UserExporter
    # @param [Hash] options the options to export users with.
    # @option options [String] :client_id the G5 OAuth client ID
    # @option options [String] :client_secret the G5 OAuth client secret
    # @option options [String] :redirect_uri the redirect URI registered with G5
    # @option options [String] :endpoint the endpoint for the G5 Auth server
    # @option options [String] :authorization_code the G5 authorization code to obtain an access token
    def initialize(options={})
      @client_id = options[:client_id]
      @client_secret = options[:client_secret]
      @redirect_uri = options[:redirect_uri]
      @endpoint = options[:endpoint]
      @authorization_code = options[:authorization_code]
    end

    # Export local users to the G5 Auth server.
    # A record will be created in G5 Auth and associated with each
    # local User. Password data is not automatically
    # exported, but is returned in a dump of SQL update
    # statements suitable for executing on the G5 Auth server.
    #
    # @return [String] SQL dump containing encrypted user passwords
    def export
      update_statements = User.all.collect do |user|
        # The user won't actually be able to log in with their usual password,
        # but at least it won't be set to a guessable value
        auth_user = auth_client.create_user(email: user.email,
                                            password: user.encrypted_password)
        update_local_user(user, auth_user)
        update_sql(auth_user.id, user.encrypted_password)
      end

      update_statements.join("\n")
    end

    private
    def update_local_user(local_user, auth_user)
      local_user.uid = auth_user.id
      local_user.provider = 'g5'
      local_user.save
    end

    def update_sql(uid, password)
      "update users set encrypted_password='#{password}' where id=#{uid};"
    end

    def auth_client
      @oauth_client ||= G5AuthenticationClient::Client.new(client_id: @client_id,
                                        client_secret: @client_secret,
                                        redirect_uri: @redirect_uri,
                                        endpoint: @endpoint,
                                        authorization_code: @authorization_code)
    end
  end

end
