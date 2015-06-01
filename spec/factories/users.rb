FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
		email { Faker::Internet.email }
		password_digest { User.digest "wildhorses" }

		factory :invalid_user do
			full_name nil
		end
  end

end
