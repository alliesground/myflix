def valid_sign_in(user)
  visit login_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: 'wildhorses'
  click_button 'Sign in'
end

def click_video_on_home_page(video)
  visit home_path
  find("a[data-video-id='#{video.id}']").click
end

def sign_out
  visit login_path
  within('div#user_links') do
    find("a[id='dlabel']").click
    click_link 'Sign Out'
  end
end

def expect_to_follow(other_user)
  within('table') do
    expect(page).to have_selector("a[href='/users/#{other_user.id}']")
  end
end