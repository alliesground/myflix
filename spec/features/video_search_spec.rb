require 'spec_helper'

feature "Video search" do
  context "with authenticated user" do
    let(:user) { create(:user) }
    let(:futurama) { create(:video) }
    background{
      valid_sign_in user
    }

    scenario "lists searched videos" do
      visit home_path
      fill_in 'search', with: 'futurama'
      click_button 'Search'

      expect(current_path).to eq search_videos_path
    end
  end
end