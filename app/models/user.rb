class User < ApplicationRecord
  VALID_ATTRIBUTES = %i(citizen_id name birth gender phone address).freeze

  belongs_to :account
  has_many :borrow_books, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :author_followers, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :books, through: :carts, dependent: :destroy

  enum gender: {male: 0, female: 1}

  validates :citizen_id, presence: true, length: {is: Settings.digit_12}
  validates :name, presence: true, length: {maximum: Settings.digit_50}
  validates :birth, presence: true
  validates :phone, presence: true
  validates :address, presence: true, length: {maximum: Settings.digit_255}
  scope :for_account, ->(account_id){where(account_id:)}
  scope :order_by_name, ->{order(:name)}
  scope :banned, (lambda do
    joins(:account).where(accounts: {status: Settings.status.banned})
  end)
  scope :overdue, (lambda do
    joins(:borrow_books, :account)
    .merge(BorrowBook.overdue)
    .where(accounts: {status: Settings.status.active})
    .distinct
  end)
  scope :neardue, (lambda do
    joins(:borrow_books).merge(BorrowBook.near_due)
  end)

  def send_due_reminder
    UserMailer.with(user: self).reminder_email.deliver_now
  end

  def books_in_carts
    books
  end

  class << self
    def with_status status
      if status.present? && respond_to?(status)
        public_send(status)
      else
        all
      end
    end
  end
end
