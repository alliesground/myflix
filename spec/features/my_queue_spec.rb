require 'spec_helper'

feature "Queue management" do
  context "with authenticated user" do
    let(:user) { create(:user) }
    background do
      valid_sign_in(user)
      @futurama = create(:video, title: 'futurama')
      @south_park = create(:video, title: 'south_park')
    end

    scenario "adds a video to the queue" do
      add_video_to_queue(@futurama)
      expect(QueueItem.first.video).to eq @futurama
      expect(current_path).to eq my_queue_path
      expect(page).to have_content @futurama.title
    end

    scenario "updates position of the video in the queue" do
      add_video_to_queue(@futurama)
      add_video_to_queue(@south_park)
      visit my_queue_path
      fill_in "video#{@futurama.id}_position", with: 2
      fill_in "video#{@south_park.id}_position", with: 1
      click_button 'Update Instant Queue'

      expect(current_path).to eq my_queue_path
      expect_video_position(@futurama, 2)
    end

    def add_video_to_queue(video)
      visit home_path
      find("a[data-video-id='#{video.id}']").click
      click_link '+ My Queue'
    end

    def expect_video_position(video, position)
      expect(find("#video#{video.id}_position").value).to eq(position.to_s)
    end
  end
end