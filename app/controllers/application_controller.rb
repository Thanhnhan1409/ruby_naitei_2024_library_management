class ApplicationController < ActionController::Base
  layout "application"
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale
  before_action :set_categories

  def is_admin_role?
    return if current_account.is_admin

    flash[:error] = t "noti.permission_err"
    redirect_to root_path
  end
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_categories
    @categories = Category.includes(:subcategories).no_parent_category
    @current_category = Category.find_by(id: params[:category])
  end
end
