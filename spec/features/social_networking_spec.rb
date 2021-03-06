require 'spec_helper'

feature 'Social Networking' do
  context "with authenticated user" do
    given(:user) { create(:user) }
    given(:other_user) { create(:user) }
    given(:futurama) { create(:video, title: 'futurama') }
    background do
      valid_sign_in(user)
      create(:review, video: futurama, user: other_user)
    end

    scenario "follows other users" do
      follow_user(other_user, futurama)
      expect_to_follow(other_user)
    end

    scenario "unfollows other users" do
      follow_user(other_user, futurama)
      unfollow_user
      expect_to_unfollow(other_user)
    end

    def follow_user(other_user, video)
      click_video_on_home_page(video)
      within(:css, "article.review") do
        find("a[href='/users/#{other_user.id}']").click
      end
      find("a[href='/relationships?followed_id=#{other_user.id}']").click
    end

    def unfollow_user
      visit people_path
      within('table') do
        find("a[href='/relationships/#{Relationship.first.id}']").click
      end
    end

    def expect_to_unfollow(other_user)
      expect(page).to_not have_selector("a[href='/users/#{other_user.id}']")
    end
  end
end