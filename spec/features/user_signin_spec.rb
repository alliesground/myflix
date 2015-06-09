require 'spec_helper'

feature "User sign_in" do
  let(:user) { create(:user) }
  background do
    visit login_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: 'wildhorses'
    click_button 'Sign in'
  end

  scenario "signs in user" do
    expect(page).to have_content "Logged in successfully"
  end

  scenario "redirects to the home page" do
    expect(current_path).to eq home_path
  end
end