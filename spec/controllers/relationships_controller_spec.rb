require 'spec_helper'

describe RelationshipsController do

  describe 'GET #index' do
    context "with unauthorized user" do
      it_behaves_like 'require sign in' do
        let(:action) { get :index }
      end
    end

    context "with authorized user" do
      login_user

      it "sets @relationships with collection of relationships initiated by signed in user" do
        user1 = create(:user)
        user2 = create(:user)
        rel1 = create(:relationship, follower: current_user, followed_id: user1)
        rel2 = create(:relationship, follower: current_user, followed_id: user2)
        get :index

        expect(assigns(:relationships)).to match_array([rel1, rel2])
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like 'require sign in' do
      let(:action) { post :create }
    end

    context "with authenticated user" do
      login_user
      let(:user) { create(:user) }
      before :each do
        post :create, followed_id: user
      end

      it "creates a relationship" do
        expect(Relationship.count).to eq 1
      end

      specify "current user follows a user" do
        expect(current_user.followed_users).to match_array([user])
      end

      it "redirects to people page" do
        expect(response).to redirect_to people_path
      end
    end


    context "when a user is already being followed by the current user" do
      login_user
      let(:user) { create(:user) }
      before :each do
        rel1 = create(:relationship, follower: current_user, followed_id: user.id)
        post :create, followed_id: user
      end

      it "does not create a relationship" do
        expect(Relationship.count).to eq 1
      end

      it "redirects to the root path" do
        expect(response).to redirect_to people_path
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: 1 }
    end

    context "with authenticated user" do
      login_user

      it "destroys the relationship of the current_user with the followed user" do
        user = create(:user)
        rel1 = create(:relationship, follower: current_user, followed_id: user.id)
        delete :destroy, id: rel1.id
        expect(current_user.followed_users).to match_array([])
      end

      it "redirects to people page" do
        user = create(:user)
        rel1 = create(:relationship, follower: current_user, followed_id: user.id)
        delete :destroy, id: rel1.id
        expect(response).to redirect_to people_path
      end

      it "does not destroy relationships that does not belong to current user" do
        followed_user = create(:user)
        other_follower = create(:user)
        rel1 = create(:relationship, follower: other_follower, followed_id: followed_user.id)
        delete :destroy, id: rel1.id
        expect(Relationship.count).to be 1
      end
    end
  end
end