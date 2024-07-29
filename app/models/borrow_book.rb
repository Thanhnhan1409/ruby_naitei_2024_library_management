class BorrowBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :request

  validates :borrow_date, :is_borrow, presence: true

  scope :overdue, (lambda do
                     where("borrow_date < ? AND is_borrow = ?",
                           Settings.day_7.days.ago.to_date, true)
                   end)
  scope :near_due, (lambda do
                      where("DATEDIFF(CURDATE(), borrow_date) BETWEEN ? AND ?
                      AND is_borrow = ?", Settings.day_5, Settings.day_7, true)
                      .order("borrow_date ASC")
                    end)
  scope :count_for_user, lambda {|user_id|
                           where(user_id:, is_borrow: true).count
                         }
end
