require 'devise_g5_authenticatable/g5/user_synchronizer'

namespace :g5 do
  desc "Update auth user roles with existing local user roles based on email address"
  task :sync_user_roles, [:username, :password, :client_id, :client_secret, :endpoint] => :environment do |t, args|
    args.with_defaults(endpoint: ENV['G5_AUTH_ENDPOINT'],
                       client_id: ENV['G5_AUTH_CLIENT_ID'],
                       client_secret: ENV['G5_AUTH_CLIENT_SECRET'],
                       username: ENV['G5_AUTH_USERNAME'],
                       password: ENV['G5_AUTH_PASSWORD'])
    G5::UserSynchronizer.new(args).sync_roles
  end
end
