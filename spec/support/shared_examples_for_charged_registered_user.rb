shared_examples "charged registered user" do
  it "saves the email attribute in lower case" do
    expect(assigns(:user).email).to eq assigns(:user).email.downcase
  end

  it "redirects to login page" do
    post :create, user: attributes_for(:user)
    expect(response).to redirect_to login_path
  end

  it "send registration notification to the user" do
    message = ActionMailer::Base.deliveries.last
    expect(ActionMailer::Base.deliveries).to be_present
  end
end