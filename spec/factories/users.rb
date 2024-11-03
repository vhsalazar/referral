FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.unique.email }
    password_digest { BCrypt::Password.create(Faker::Internet.password(min_length: 8)) }
    referral_code { Faker::Alphanumeric.alphanumeric(number: 10) }
    referred_by { nil } # Allows for users without a referral; can be set to another User if needed

    # Nested factory for creating a referred user
    factory :user_with_referrer do
      association :referred_by, factory: :user
    end
  end
end
