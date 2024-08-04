class RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    @request = Request.new
    @books = current_user.books_in_carts
  end

  def create
    @request = current_user.requests.build(request_params)
    selected_books = fetch_selected_books

    return if handle_empty_books(selected_books) ||
              handle_book_limit(selected_books) ||
              handle_borrowed_books_limit(selected_books)

    process_request selected_books
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "noti.request_failure_noti"
    render :new
  end

  def show
    @pending_requests = Request.includes(borrow_books: :book).where(
      status: :pending, user: current_user
    )
    @approved_requests = Request.includes(borrow_books: :book).where(
      status: :approved, user: current_user
    )
    @rejected_requests = Request.includes(borrow_books: :book).where(
      status: :rejected, user: current_user
    )
    @canceled_requests = Request.includes(borrow_books: :book).where(
      status: :cancel, user: current_user
    )
  end

  def update_status
    @request = Request.find(params[:id])
    if @request.update(status: params[:status],
                       description: params[:description])
      render json: {success: true}
    else
      render json: {success: false, errors: @request.errors.full_messages}
    end
  end

  private
  def fetch_requests_with_books requests
    requests.includes(:books) # Assuming a request has many books
  end

  def fetch_selected_books
    Book.in_user_cart(current_user)
  end

  def handle_empty_books selected_books
    return if selected_books.present?

    flash[:warning] = t "noti.empty_request_noti"
    redirect_to new_request_path
    true
  end

  def handle_book_limit selected_books
    return unless selected_books.count > Settings.max_books

    flash[:warning] = t "noti.over_limit_request_noti"
    redirect_to new_request_path
    true
  end

  def handle_borrowed_books_limit selected_books
    borrowed_books_count = BorrowBook.borrowed_by_user(current_user).count
    pending_books = Request.pending_for_user(current_user).count
    cart_books = current_user.carts.count
    total_books_count = borrowed_books_count + pending_books + cart_books

    if total_books_count + selected_books.size > 5
      flash[:warning] = t "noti.over_limit_request_noti"
      redirect_to new_request_path
      return true
    end

    false
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
      redirect_to request_show_path
    end
  end

  def request_params
    params.require(:request).permit(:status, :description)
  end
end
