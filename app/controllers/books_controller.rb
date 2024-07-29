class BooksController < ApplicationController
  include Pagy::Backend
  before_action :load_book, only: :show
  def index
    @category = Category.find_by(id: params[:category])
    @total_books = filtered_books.to_a.size
    @keywords = params[:search]
    @pagy, @books = pagy(filtered_books)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @related_books = get_related_books
  end

  private
  def filtered_books
    Book.filter_by_category(@category)
        .filter_by_search(params[:search])
        .sorted_by(params[:sort])
  end

  def get_related_books
    category = @book.category
    category_ids = [category.id]
    category_ids += category.subcategories.pluck(:id) if category.parent_id.nil?
    Book.filter_related_books(category_ids, @book.id)
  end

  def load_book
    @book = Book.find_by(id: params[:id])
    return if @book

    flash[:danger] = t "noti.book_not_found"
    redirect_to books_path
  end
end
