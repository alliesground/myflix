require 'spec_helper'

feature "Reset Password" do
  given(:john) { create(:user, password: 'old_password') }
  background do
    clear_emails
  end

  scenario "resets users forgotten password" do
    provide_email

    open_email(john.email)

    click_link_to_reset_password

    reset_password

    signin_with_new_password

    expect_successful_sign_in
  end

  def provide_email
    visit forgot_password_path
    fill_in 'Email Address', with: john.email
    click_button 'Send Email'
  end

  def click_link_to_reset_password
    current_email.click_link reset_password_path(john.token)
  end

  def reset_password
    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'
  end

  def signin_with_new_password
    fill_in 'Email Address', with: john.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign in'
  end

  def expect_successful_sign_in
    within 'div.alert' do
      expect(page).to have_content "Logged in successfully"
    end
    expect(page).to have_content "Welcome, #{john.full_name}"
  end
end