require 'spec_helper'

describe Category do
  it {should have_many :videos}
  it "saves itself" do
    category = build(:category)
    category.save
    expect(Category.first).to eq category
  end

  it "contains many videos" do
    cat_commedy = create(:category)
    futurama = create(:video, category: cat_commedy)
    south_park = create(:video, title: "south_park", category: cat_commedy)

    expect(cat_commedy.videos).to eq([futurama, south_park])
  end

  describe '#recent_videos' do
    before :each do
      @cat_drama = create(:category, name: 'drama')
      @cat_reality = create(:category, name: 'reality')
      @videos = create_list(:video, 7, category: @cat_reality)
    end

    it "returns latest videos" do
      expect(@cat_reality.recent_videos.first).to eq @videos.last
    end

    context "with less than 6 videos" do
      it "returns all of it" do
        create(:video, category: @cat_drama)
        expect(@cat_drama.recent_videos.size).to eq(1)
      end
    end

    context "with more than 6 videos" do
      it "returns most recent 6" do
        expect(@cat_reality.recent_videos.size).to eq(6)
      end
    end

    context "with no videos in the category" do
      it "returns empty array" do
        expect(@cat_drama.recent_videos).to match_array([])
      end
    end
  end
end
