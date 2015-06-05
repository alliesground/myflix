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

  describe 'POST #create' do
    context "with authenticated user" do
      let(:current_user) { create(:user) }
      before { session[:user_id] = current_user.id }

      it "saves the queue item assocaited with the video" do
        video = create(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq video
      end

      it "saves the queue item associated with the signed in user" do
        video = create(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq current_user
      end

      it "creates a queue item in incrementing order" do
        queue_item1 = create(:queue_item, user: current_user)
        video = create(:video)
        post :create, video_id: video.id
        expect(QueueItem.last.position).to eq(2)
      end

      it "does not add a video if it already exists in the queue of a signed in user" do
        video = create(:video)
        queue_item = create(:queue_item, video: video, user: current_user)
        expect{
          post :create, video_id: video.id
          }.to_not change(QueueItem, :count)
      end
    end

    it "redirects to root path for unauthenticated user" do
      post :create
      expect(response).to redirect_to root_path
    end
  end

  describe 'DELETE #destroy' do
    context "with authenticated user" do
      let(:current_user) { create(:user) }
      before { session[:user_id] = current_user.id }

      it "deletes the queue item for the signed in user" do
        queue_item = create(:queue_item, user: current_user)
        expect{
          delete :destroy, id: queue_item.id
        }.to change(QueueItem, :count).by(-1)
      end

      it "redirects to the my_queue page" do
        queue_item = create(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "does not delete the queue if it does not belong to current user" do
        other_user = create(:user)
        queue_item = create(:queue_item, user: other_user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.find_by(id: queue_item.id)).to_not be nil
      end
    end

    it "redirects to the root page for unauthenticated user" do
      queue_item = create(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to root_path
    end
  end
end