FactoryGirl.define do
  factory :video do
    association :category
    title { Faker::Lorem.words(2).join(' ') }
    description { Faker::Lorem.paragraph(2) }
    small_cover_url ''
    large_cover_url ''
  end
end