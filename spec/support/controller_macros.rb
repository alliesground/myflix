module ControllerMacros
  def login_user(user=nil)
    let(:current_user) { (user || create(:user)) }
    before :each do
      session[:user_id] = current_user.id
    end
  end

  def login_admin
    let(:current_user) { create(:admin) }
    before :each do
      session[:user_id] = current_user.id
    end
  end

  def successful_stripe_charge
    before :each do
      charge = double('charge')
      charge.stub(:success?).and_return(true)
      StripeWrapper::Charge.stub(:create).and_return(charge)
    end
  end

  def unsuccessful_stripe_charge
    before :each do
      charge = double('charge')
      charge.stub(:success?).and_return(false)
      charge.stub(:error_message).and_return("Your card was declined")
      StripeWrapper::Charge.stub(:create).and_return(charge)
    end
  end

end