class RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    @request = Request.new
    @books = current_user.books_in_carts
  end

  def create
    @request = current_user.requests.build(request_params)
    selected_books = fetch_selected_books

    return if handle_errors(selected_books)

    process_request(selected_books)
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "noti.request_failure_noti"
    render :new
  end

  def index
    @requests = Request.includes(:borrow_books)

    if params[:status].present?
      @requests = @requests.filter_by_status(params[:status])
    end

    return if params[:search].blank?

    @requests = @requests.search_by_book(params[:search])
  end

  def update
    @request = Request.find_by(id: params[:id])

    if @request.nil?
      render_not_found
    elsif @request.update(request_params)
      handle_approved_status if params[:status] == "approved"
      render json: {success: true}
    else
      render_update_error
    end
  end

  private

  def fetch_requests_with_books requests
    requests.includes(:books)
  end

  def fetch_selected_books
    Book.in_user_cart(current_user)
  end

  def handle_errors selected_books
    if selected_books.blank?
      flash[:warning] = t "noti.empty_request_noti"
      redirect_to new_request_path
      true
    elsif selected_books.count > Settings.max_books
      flash[:warning] = t "noti.over_limit_request_noti"
      redirect_to new_request_path
      true
    elsif exceed_borrow_limit?(selected_books)
      flash[:warning] = t "noti.over_limit_request_noti"
      redirect_to new_request_path
      true
    else
      false
    end
  end

  def exceed_borrow_limit? selected_books
    borrowed_books_count = BorrowBook.borrowed_by_user(current_user).count
    pending_books = Request.pending_for_user(current_user).count
    total_books_count = borrowed_books_count + pending_books

    total_books_count + selected_books.size > Settings.max_books
  end

  def process_request selected_books
    ActiveRecord::Base.transaction do
      @request.save!
      selected_books.each do |book|
        BorrowBook.create!(
          user: current_user,
          book:,
          request: @request,
          borrow_date: Time.current,
          is_borrow: false
        )
        current_user.carts.where(book_id: book.id).destroy_all
      end
      flash[:success] = t "noti.request_success_noti"
      redirect_to requests_path
    end
  end

  def request_params
    params.require(:request).permit(:status, :description)
  end

  def handle_approved_status
    @request.borrow_books.update_all(is_borrow: true)
  end

  def render_not_found
    render json: {success: false, error: "Request not found"},
           status: :not_found
  end

  def render_update_error
    render json: {success: false, errors: @request.errors.full_messages}
  end
end
