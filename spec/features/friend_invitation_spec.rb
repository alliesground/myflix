require 'spec_helper'

feature 'Friend invitation' do
  given(:user) { create(:user, full_name: 'Antonio') }
  given(:invited_user) { {:name => "invited_user", :email => "invited_user@example.com"} }
  background do
    valid_sign_in(user)
  end

  scenario "invites a friend for registration through email" do
    send_invitation_to(invited_user)

    expect_invitation_sent_to(invited_user[:email])

    follow_email_link_to_register(invited_user[:email])

    register_invited_user

    sign_in_invited_user(invited_user)

    expect(page).to have_content "Welcome, Invited User"
  end

  scenario "invited friend follows the inviter" do
    send_invitation_to(invited_user)

    follow_email_link_to_register(invited_user[:email])

    register_invited_user

    sign_in_invited_user(invited_user)

    visit people_path

    expect_to_follow(user)
  end

  def send_invitation_to(invited_user)
    visit invite_path
    fill_in "Friend's Name", with: invited_user[:name]
    fill_in "Friend's Email Address", with: invited_user[:email]
    fill_in "Invitation Message", with: 'please join myflix'
    click_button "Send Invitation"
  end

  def expect_invitation_sent_to(email)
    open_email(email)
    expect(current_email).to have_link 'Register'
  end

  def follow_email_link_to_register(email)
    open_email(email)
    current_email.click_link 'Register'
  end

  def register_invited_user
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Invited User'
    click_button 'Sign Up'
  end

  def sign_in_invited_user(invited_user)
    sign_out
    visit login_path
    fill_in 'Email Address', with: invited_user[:email]
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
  end
end