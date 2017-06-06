# frozen_string_literal: true

FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin.#{n}@test.host" }
    password 'my_new_secret'
    password_confirmation 'my_new_secret'
    provider 'g5'
    sequence(:uid) { |n| "remote-admin-#{n}" }
    sequence(:g5_access_token) { |n| "token-abc123-#{n}" }
  end
end
