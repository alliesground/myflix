def valid_sign_in(user)
	visit login_path
	fill_in 'Email Address', with: user.email
	fill_in 'Password', with: 'wildhorses'
	click_button 'Sign in'
end