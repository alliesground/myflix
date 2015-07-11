class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def save_with_payment(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999, 
        currency: "usd", 
        source: stripe_token
      )

      if charge.success?
        @user.save
        UserMailer.welcome_registered_user(@user).deliver
        handle_invitation(invitation_token)
        @status = :success
        self
      else
        @status = :fail
        @error_message = charge.error_message
        self
      end
    else
      @status = :fail
      @error_message = "Invalid user information."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.update_column(:token, nil)
    end
  end
end