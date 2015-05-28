require 'spec_helper'

describe Video do
	it "saves itself" do
		video = build(:video)
		video.save
		expect(Video.first).to eq video
	end

	it {should belong_to :category}
	it {should validate_presence_of :title}
	it {should validate_presence_of :description}

end
