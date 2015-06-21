require 'spec_helper'

feature 'Add Video' do
  given(:admin) { create(:admin) }
  given(:user) { create(:user) }
  background do
    create(:category, name: 'dramas')
    valid_sign_in(admin)
  end
  scenario "admin adds a video" do
    add_video

    sign_out
    valid_sign_in(user)

    visit video_path(Video.first)

    expect(page).to have_video_cover
    expect(Video.count).to eq 1

  end

  def add_video
    visit new_admin_video_path
    fill_in 'Title', with: "one fine day"
    select 'dramas', from: 'Category'
    fill_in 'Description', with: 'Lorem ipsum'
    attach_file 'Large cover url', 'public/tmp/family_guy.jpg'
    click_button 'Add Video'
  end

  def have_video_cover
    have_selector("img[src='/uploads/video/large_cover_url/#{Video.first.id}/family_guy.jpg']")
  end
end