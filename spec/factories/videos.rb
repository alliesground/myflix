FactoryGirl.define do
	factory :video do
		association :category
		title 'futurama'
		description 'Greate TV series'
		small_cover_url ''
		large_cover_url ''
	end
end