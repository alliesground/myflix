FactoryGirl.define do
  factory :review do
    association :user
    association :video
    rating { rand(1..5) }
    body { Faker::Lorem.paragraph }
  end 
end