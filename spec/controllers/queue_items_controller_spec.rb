require 'spec_helper'

describe QueueItemsController do
  describe 'GET #index' do
    context "with authenticated user" do
      let(:current_user) { create(:user) }
      before { session[:user_id] = current_user.id }

      it "sets @queue_items to the queue items associated with the logged in user" do
        queue_item1 = create(:queue_item, user: current_user)
        queue_item2 = create(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end

    context "with unauthenticated user" do
      it "redirects to root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end