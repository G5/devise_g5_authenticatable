FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user.#{n}@test.host" }
    password 'my_dark_secret'
  end
end
