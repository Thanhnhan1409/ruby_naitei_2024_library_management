class Admin::BooksController < Admin::ApplicationController
  before_action :load_book, only: %i(destroy edit update)
  def index
    @pagy, @books = pagy Book.order_by_title, items: Settings.books_per_page
  end

  def destroy
    if @book.destroy
      flash[:success] = t "noti.book_delete_success"
    else
      flash[:danger] = t "noti.book_delete_fail"
    end
    redirect_to admin_books_path
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params

    if @book.save
      flash[:success] = t "noti.book_created_success"
      redirect_to admin_books_path
    else
      flash[:warning] = t "noti.book_created_fail"
      redirect_to new_admin_book_path
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      flash[:success] = t "noti.book_updated_success"
      redirect_to admin_books_path
    else
      flash[:warning] = t "noti.book_updated_fail"
      redirect_to edit_admin_book_path
    end
  end

  def borrowed_books
    @pagy, @borrowed_books = pagy(
      BorrowBook
        .borrowed
        .with_details
    )
  end

  private

  def load_book
    @book = Book.find_by(id: params[:id])
    return if @book

    flash[:danger] = t "noti.book_not_found"
    redirect_to books_path
  end

  def book_params
    params.require(:book).permit Book::BOOK_PARAMS
  end
end
