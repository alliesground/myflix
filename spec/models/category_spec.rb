require 'spec_helper'

describe Category do
	it {should have_many :videos}
	it "saves itself" do
		category = build(:category)
		category.save
		expect(Category.first).to eq category
	end

	it "contains many videos" do
		cat_commedy = create(:category)
		futurama = create(:video, category: cat_commedy)
		south_park = create(:video, title: "south_park", category: cat_commedy)

		expect(cat_commedy.videos).to eq([futurama, south_park])
	end
end
