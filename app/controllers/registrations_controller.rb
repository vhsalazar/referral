class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    signup_service = Users::SignupUserService.new(user_params)

    if signup_service.call
      @user = signup_service.user
      start_new_session_for @user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      @user = signup_service.user
      flash.now[:alert] = "There was a problem with your registration."
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :referer_code)
  end
end
