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
      expect_queue_to_have_video(@futurama)
    end

    scenario "updates position of the video in the queue" do
      add_video_to_queue(@futurama, @south_park)

      update_video_position(@futurama => 2, @south_park => 1)

      expect_video_position(@futurama, 2)
    end

    def add_video_to_queue(*videos)
      videos.each do |video|
        click_video_on_home_page(video)
        click_link '+ My Queue'
      end
    end

    def expect_queue_to_have_video(video)
      expect(QueueItem.first.video).to eq video
      expect(page).to have_content video.title
    end

    def update_video_position(options={})
      visit my_queue_path
      options.map do |key, val|
        fill_in "video#{key.id}_position", with: val
      end
      click_button 'Update Instant Queue'
    end

    def expect_video_position(video, position)
      expect(find("#video#{video.id}_position").value).to eq(position.to_s)
    end
    
  end
end