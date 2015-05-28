FactoryGirl.define do
	factory :video do
		association :category
		title 'futurama'
		description 'Futurama a great commedy'
		small_cover_url ''
		large_cover_url ''
	end
end