require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: 'futurama', description: "new series")
		video.save
		expect(Video.first).to eq video
	end
end
