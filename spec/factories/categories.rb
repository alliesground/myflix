FactoryGirl.define do
  factory :category do
    name 'commedy'

    factory :invalid_category do
      name nil
    end
  end
end