FactoryGirl.define do
  factory :review do
    rating { rand(1..5) }
    body { Faker::Lorem.paragraph }
    association :user
    association :video

    factory :invalid_review do
      body nil
    end
  end 
end