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

  describe '#video_category' do
    it "returns the category instance of the associated video in a queue item" do
      category = create(:category, name: 'drama')
      video = create(:video, category: category)
      queue_item = create(:queue_item, video: video)
      expect(queue_item.video_category).to be_an_instance_of Category
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

  describe '#rating=' do
    it "updates the rating of the review if the review is present" do
      video = create(:video)
      user = create(:user)
      review = create(:review, video: video, user: user, rating: 1)
      queue_item = create(:queue_item, video: video, user: user)
      queue_item.rating = 2
      expect(review.reload.rating).to eq 2
    end

    it "creates a new review if the review is not present" do
      video = create(:video)
      user = create(:user)
      queue_item = create(:queue_item, video: video, user: user)
      expect {
        queue_item.rating = 2
      }.to change(Review, :count).by(1)
    end

    it "clears the rating of the review if the review is present" do
      video = create(:video)
      user = create(:user)
      review = create(:review, video: video, user: user, rating: 2)
      queue_item = create(:queue_item, video: video, user: user)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    context "when review is present with empty rating" do
      it "updates the rating" do
        video = create(:video)
        user = create(:user)
        review = build(:review, video: video, user: user, rating: nil)
        review.save(validate: false)
        queue_item = create(:queue_item, video: video, user: user)
        queue_item.rating = 1
        expect(review.reload.rating).to eq 1
      end
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