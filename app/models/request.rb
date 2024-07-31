class Request < ApplicationRecord
  enum status: {pending: 0, approved: 1, rejected: 2}
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  validates :status, presence: true
  scope :pending_for_user, ->(user){where(user:, status: :pending)}
end
