class Admin::BorrowBooksController < ApplicationController
  def mark_as_returned
    @borrow_book = BorrowBook.find_by(
      book_id: params[:book_id],
      request_id: params[:request_id]
    )

    if @borrow_book.present?
      if @borrow_book.update(is_borrow: false)
        flash[:success] = t "noti.book_returned_success"
      else
        flash[:danger] = t "noti.book_returned_fail"
      end
    else
      flash[:danger] = t "noti.book_not_found"
    end

    redirect_to borrowed_books_admin_books_path
  end
end
