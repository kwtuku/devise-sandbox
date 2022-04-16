FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :from_github do
      provider { 'github' }
      uid { SecureRandom.random_number(1 << 64) }
    end

    trait :from_google do
      provider { 'google_oauth2' }
      uid { SecureRandom.random_number(1 << 64) }
    end
  end
end
