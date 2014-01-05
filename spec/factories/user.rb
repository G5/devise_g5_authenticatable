FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user.#{n}@test.host" }
    password 'my_new_secret'
    password_confirmation 'my_new_secret'
    provider 'g5'
    sequence(:uid) { |n| "remote-user-#{n}" }
  end
end
