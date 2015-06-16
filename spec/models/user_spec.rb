require 'spec_helper'

describe User do
  it { should validate_presence_of :full_name}
  it { should validate_presence_of :email}
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:email).is_at_most(255) }
  it { should allow_value('ben@example.com').for(:email) }
  it { should_not allow_value('ben.com').for(:email) }
  it { should have_many :reviews }

  it "generates random token when user is created" do
    user = create(:user)
    expect(user.token).to be_present
  end

  describe '#reviews_count' do
    context "with 1 review" do
      it "returns the singularized count of the review associated with a user" do
        user = create(:user)
        review = create(:review, user: user)
        expect(user.reviews_count). to eq "Review (1)"
      end
    end

    context "with more than 1 reviews" do
      it "returns the pluralized count of the reviews associated with a user" do
        user = create(:user)
        review1 = create(:review, user: user)
        review2 = create(:review, user: user)
        expect(user.reviews_count). to eq "Reviews (2)"
      end
    end

    context "with no reviews" do
      it "returns the pluralized count with 0 as the value" do
        user = create(:user)
        expect(user.reviews_count). to eq "Reviews (0)"
      end
    end
  end
end
