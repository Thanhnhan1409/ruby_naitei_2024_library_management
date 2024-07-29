class Admin::UsersController < Admin::ApplicationController
  before_action :load_user, only: :due_reminder
  def index
    @pagy, @users = pagy User.order_by_name.with_status(params[:status]),
                         items: Settings.users_per_page
  end

  def due_reminder
    @user.send_due_reminder
    flash[:success] = t "due_reminder_success", user_name: @user.name
    redirect_to users_path status: "neardue"
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "noti.not_found"
    redirect_to root_path
  end
end
