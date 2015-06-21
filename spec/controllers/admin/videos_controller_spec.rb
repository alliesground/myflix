require 'spec_helper'

describe Admin::VideosController do
  describe 'GET #new' do
    it_behaves_like 'require sign in' do
      let(:action) { get :new }
    end

    context "when authenticated user is admin" do
      login_admin

      it "sets @video with an instance of Video" do
        get :new
        expect(assigns(:video)).to be_an_instance_of Video
      end
    end

    context "when authenticated user is not admin" do
      login_user

      it "redirects to root_path" do
        get :new
        expect(response).to redirect_to root_path
      end

      it "sets flash warning message" do
        get :new
        expect(flash[:warning]).to be_present
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like 'require sign in' do
      let(:action) { post :create, video: attributes_for(:video) }
    end

    context "when authenticated user is admin" do
      login_admin

      context "with valid attributes" do
        before :each do
          category = create(:category, name: 'commedy')
          post :create, video: { title:'my-video', description:'Lorem ipsum', category_id: category.id }
        end

        it "redirects to video new page" do
          expect(response).to redirect_to new_admin_video_path
        end

        it "saves a video into the database" do
          expect(Video.count).to eq 1
        end

        it "saves a video associated with a category" do
          expect(Video.first.category.name).to eq 'commedy'
        end

        it "uploaded pictures into amazon s3" do
          
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, video: { title:'my-video', description: nil, category_id: nil }
        end

        it "renders :new template" do
          expect(response).to render_template :new
        end
      end
    end
  end
end