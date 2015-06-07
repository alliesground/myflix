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

      it "normalizes the position of the remaining queue items" do
        queue_item1 = create(:queue_item, user: current_user, position: 1)
        queue_item2 = create(:queue_item, user: current_user, position: 2)
        queue_item3 = create(:queue_item, user: current_user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end
    end

    it "redirects to the root page for unauthenticated user" do
      queue_item = create(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'PATCH #update' do
    context "with authenticated user" do
      let(:current_user) { create(:user) }
      before { session[:user_id] = current_user.id }

      it "redirects to my_queue page" do
        queue_item1 = create(:queue_item)
        queue_item2 = create(:queue_item)
        patch :update, items:[
          {id: queue_item1.id}, 
          {id: queue_item2.id}
        ]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders queue items" do
        queue_item1 = create(:queue_item, position: 1, user: current_user)
        queue_item2 = create(:queue_item, position: 2, user: current_user)
        patch :update, items:[
          {id: queue_item1.id, position: 2}, 
          {id: queue_item2.id, position: 1}
        ]
        expect(current_user.queue_items). to eq([queue_item2, queue_item1])
      end

      it "normalizes the position number" do
        queue_item1 = create(:queue_item, position: 1, user: current_user)
        queue_item2 = create(:queue_item, position: 2, user: current_user)
        queue_item3 = create(:queue_item, position: 3, user: current_user)
        patch :update, items:[
          {id: queue_item1.id, position: 3}, 
          {id: queue_item2.id, position: 2},
          {id: queue_item3.id, position: 3}
        ]
        expect(current_user.queue_items.map(&:position)).to eq([1,2,3])
      end

      context "with invalid inputs" do
        it "does not update any of the queue_item positions" do
          queue_item1 = create(:queue_item, position: 1, user: current_user)
          queue_item2 = create(:queue_item, position: 2, user: current_user)
          patch :update, items:[
            {id: queue_item1.id, position: 2},
            {id: queue_item2.id, position: 2.3}
          ]
          queue_item1.reload
          expect(queue_item1.position).to eq 1
        end

        it "redirect to my_queue path" do
          queue_item1 = create(:queue_item, position: 1, user: current_user)
          queue_item2 = create(:queue_item, position: 2, user: current_user)
          patch :update, items:[
            {id: queue_item1.id, position: 2},
            {id: queue_item2.id, position: 2.3}
          ]
          expect(response).to redirect_to my_queue_path
        end
      end
    end

    context "with unauthenticated users" do
      it "redirect to root path" do
        queue_item1 = create(:queue_item, position: 1)
        queue_item2 = create(:queue_item, position: 2)
        patch :update, items:[
          {id: queue_item1.id, position: 2},
          {id: queue_item2.id, position: 1}
        ]
        expect(response).to redirect_to root_path
      end
    end

    context "when current_user tries to updates others queue items" do
      it "redirect to my_queue page without updating the queue item" do
        current_user = create(:user)
        session[:user_id] = current_user.id
        other_user = create(:user)
        queue_item1 = create(:queue_item, position: 1, user: other_user)
        queue_item2 = create(:queue_item, position: 2, user: other_user)
        patch :update, items:[
          {id: queue_item1.id, position: 2},
          {id: queue_item2.id, position: 1}
        ]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end