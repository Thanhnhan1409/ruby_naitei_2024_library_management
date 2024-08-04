class Request < ApplicationRecord
  enum status: {pending: 0, approved: 1, rejected: 2, cancel: 3}
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  validates :status, presence: true

  private

  def send_email
    if approved?
      RequestMailer.with(request: self, user:).request_approved.deliver_now
    elsif rejected?
      RequestMailer.with(request: self, user:).rejection_email.deliver_now
    end
  end
  scope :pending_for_user, lambda {|user|
                             joins(:borrow_books).where(user:, status: :pending)
                           }
end
