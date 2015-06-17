FactoryGirl.define do
  factory :invitation do
    recipient_name { Faker::Name.name }
    recipient_email { Faker::Internet.email }
    message { Faker::Lorem.paragraph }
  end
end