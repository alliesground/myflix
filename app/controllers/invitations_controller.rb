class InvitationsController < ApplicationController
  before_action :authenticate, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    params[:invitation].merge!(inviter_id: current_user.id)
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      UserMailer.send_friend_invitation(@invitation).deliver
      flash[:success] = "Invitation sent"
      redirect_to invite_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :inviter_id)
  end
end