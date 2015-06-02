require 'spec_helper'

describe Video do
  it "saves itself" do
    video = build(:video)
    video.save
    expect(Video.first).to eq video
  end

  it {should belong_to :category}
  it {should have_many :reviews}

  it {should validate_presence_of :title}
  it {should validate_presence_of :description}

  describe '#search_by_title' do
    before :each do
      @wonder_year = create(:video, title: "wonder years")
      @wonder_park = create(:video, title: "wonder park")
    end
    context "with no match" do
      it "returns empty array" do
        expect(Video.search_by_title('idol')).to match_array([])
      end
    end

    context "with single match" do
      it "returns array of single database object" do
        expect(Video.search_by_title("wonder years")).to match_array([@wonder_year])
      end
    end

    context "with multiple match" do
      it "returns array of multiple database objects" do
        expect(Video.search_by_title("wonder")).to match_array([@wonder_year,
          @wonder_park])
      end
    end

    context "with empty string as an argument" do
      it "returns an empty array" do
        expect(Video.search_by_title("")).to match_array([])
      end
    end
  end

  describe '#avg_rating' do
    it "returns average rating for a video" do
      video = create(:video)
      review_1 = create(:review, rating: 5, video: video)
      review_2 = create(:review, rating: 3, video: video)
      expect(video.avg_rating).to eq 4.0
    end
  end

end
