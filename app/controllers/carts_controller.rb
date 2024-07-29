class CartsController < ApplicationController
  def create
    if book_already_in_cart?
      flash[:danger] = t "noti.book_already_in_cart"
    else
      add_book_to_cart
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def book_already_in_cart?
    current_user.carts.exists?(book_id: params[:book_id])
  end

  def add_book_to_cart
    @cart = current_user.carts.new(book_id: params[:book_id])

    if @cart.save
      flash[:success] = t "noti.add_book_to_cart_success"
    else
      flash[:danger] = t "noti.add_book_to_cart_fail"
    end
  end
end
