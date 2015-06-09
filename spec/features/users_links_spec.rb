require 'spec_helper'

feature "Users layout links" do
  context "when signed in" do
    scenario "displays links for signed_in user" do
      user = create(:user)
      valid_sign_in user

      within '#user_links' do
        expect(page).to have_content 'Sign Out'
        expect(page).to have_content user.full_name
      end
    end
  end
end