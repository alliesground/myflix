require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it {should validate_numericality_of(:position).only_integer}

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

  describe '.duplicate?' do
    it "returns true if a video already exists in the queue for signed in user" do
      user = create(:user)
      video = create(:video)
      queue_item = create(:queue_item, video: video, user: user)
      expect(QueueItem.contains_video?(video, user)).to be_truthy
    end

    it "returns nil if video does not exist in the queue for signed in user" do
      user1 = create(:user)
      user2 = create(:user)
      video = create(:video)
      queue_item = create(:queue_item, video: video, user: user1)
      expect(QueueItem.contains_video?(video, user2)).to be nil
    end
  end
end