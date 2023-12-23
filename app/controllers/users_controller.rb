class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :authenticate_user!

  def edit
  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path, notice: t(:label_update_suсcess) }
        format.turbo_stream { flash.now[:notice] = t(:label_update_suсcess) }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:error] = t(:label_update_failed) }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end
end
