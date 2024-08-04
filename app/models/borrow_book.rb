class BorrowBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :request

  validates :borrow_date, presence: true
  validates :is_borrow, inclusion: {in: [true, false]}

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
  scope :borrowed_by_user, lambda {|user|
                             where(user:, is_borrow: true)
                           }

  scope :borrowing_by_user, lambda {|user|
                              where(user:, is_borrow: true)
                            }
end
