class SessionsController < ApplicationController
  before_action :find_account_by_email, only: [:create]

  def new; end

  def create
    if @account.authenticate params.dig(:session, :password)
      log_in_account @account
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def find_account_by_email
    @account = Account.find_by email: params.dig(:session, :email)&.downcase
    handle_invalid_login if @account.nil?
    return unless @account&.user.nil? && !@account&.is_admin

    flash[:warning] = t "noti.user_infor_404"
    redirect_to new_user_path
  end

  def log_in_account account
    reset_session
    log_in account
    remember_or_forget account
    redirect_to admin_users_path and return if account.is_admin

    redirect_back_or root_path
  end

  def remember_or_forget account
    if params.dig(:session, :remember_me) == "1"
      remember account
    else
      forget account
    end
  end

  def handle_invalid_login
    flash[:danger] = t "sign_up.invalid"
    redirect_to login_path
  end
end
