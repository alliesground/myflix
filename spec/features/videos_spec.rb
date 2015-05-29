require 'spec_helper'

feature "Video search" do
	background{
		@futurama = create(:video)
	}
	scenario "lists searched videos" do
		visit home_path
		fill_in 'search', with: 'futurama'
		click_button 'Search'

		expect(current_path).to eq search_videos_path
	end
end