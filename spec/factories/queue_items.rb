FactoryGirl.define do
  factory :queue_item do
    association :user
    association :video
    position 1
  end
end