class Admin::AccountsController < Admin::ApplicationController
  before_action :load_account, :is_admin_role?, only: %i(update update_status)

  def update_status
    if @account.toggle_status
      flash[:success] = t "noti.update_success"
    else
      flash[:danger] = t "noti.update_fail"
    end
    redirect_to users_path status: "banned"
  end

  private
  def load_account
    @account = Account.find_by(id: params[:id])
    return if @account

    flash[:danger] = t "noti.account_not_found"
    redirect_to users_path
  end
end
