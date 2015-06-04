require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }

  describe '#video_title' do
    it "returns the title of the video associated with the queue_item" do
      video = create(:video)
      queue_item = create(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe '#category_name' do
    it "returns the category name of the video associated with the queue_item" do
      category = create(:category, name: 'drama')
      video = create(:video, category: category)
      queue_item = create(:queue_item, video: video)
      expect(queue_item.category_name).to eq "drama"
    end
  end

  describe '#rating' do
    it "returns the rating on the video if the user has reviewed it" do
      user = create(:user)
      video = create(:video)
      review = create(:review, user: user, video: video, rating: 4)
      queue_item = create(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq 4
    end

    it "returns nil if user has not reviewed the video" do
      user = create(:user)
      video = create(:video)
      queue_item = create(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq nil
    end
  end
end