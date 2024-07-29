class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_action :is_admin_role?
end
