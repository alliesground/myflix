module ControllerMacros
  def login_user
    before :each do
      user = create(:user)
      session[:user_id] = user.id
    end
  end
end