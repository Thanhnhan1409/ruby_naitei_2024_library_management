class Admin::RequestsController < Admin::ApplicationController
  def index
    @requests = Request.includes(:borrow_books)

    if params[:status].present?
      @requests = @requests.filter_by_status(params[:status])
    end

    return if params[:search].blank?

    @requests = @requests.search_by_book(params[:search])
  end
end
