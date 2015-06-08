module ControllerMacros
  def login_user(user=nil)
    let(:current_user) { (user || create(:user)) }
    before :each do
      session[:user_id] = current_user.id
    end
  end
end