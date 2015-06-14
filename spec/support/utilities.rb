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