class RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    @request = Request.new
    @books = current_user.books_in_carts
  end

  def create
    @request = current_user.requests.build(request_params)
    selected_books = fetch_selected_books

    if handle_empty_books(selected_books) ||
       handle_book_limit(selected_books) ||
       handle_borrowed_books_limit(selected_books)
      return
    end

    process_request selected_books
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "noti.request_failure_noti"
    render :new
  end

  def show
    @pending_books = Book.pending_for_user(current_user)
    @borrowed_books = BorrowBook.borrowed_by_user(current_user).map(&:book)
    @borrowing_books = BorrowBook.borrowing_by_user(current_user).map(&:book)
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
    borrowed_books_count = BorrowBook.count_for_user(current_user.id)
    total_books_count = borrowed_books_count + selected_books.size

    return false if total_books_count <= Settings.max_books

    flash[:warning] = t "noti.over_limit_request_noti"
    redirect_to root_path
    true
  end

  # def show
  #   pending_requests = current_user.requests.pending
  #   approved_requests = current_user.requests.approved
  #   rejected_requests = current_user.requests.rejected

  #   @pending_requests = fetch_requests_with_books(pending_requests)
  #   @approved_requests = fetch_requests_with_books(approved_requests)
  #   @rejected_requests = fetch_requests_with_books(rejected_requests)
  # end

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
      redirect_to root_path
    end
  end

  def request_params
    params.require(:request).permit(:status)
  end
end
