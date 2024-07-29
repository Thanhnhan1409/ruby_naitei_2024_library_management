class Account < ApplicationRecord
  enum status: {active: 0, ban: 1}
  attr_accessor :remember_id

  VALID_ATTRIBUTES = %i(email password password_confirmation).freeze
  mail_regex = Regexp.new(Settings.VALID_EMAIL_REGEX)
  validates :email, presence: true,
                    length: {maximum: Settings.email_max_length},
                    format: {with: mail_regex}
  validates :password, presence: true,
                    length: {minimum: Settings.min_password_length},
                    allow_nil: true

  has_secure_password

  has_one :user, dependent: :destroy

  before_save :downcase_email

  def remember
    self.remember_id = Account.new_token
    update_column :remember_id, Account.digest(remember_id)
  end

  def authenticate? remember_id
    BCrypt::Password.new(remember_id).is_password? remember_id
  end

  def toggle_status
    active? ? ban! : active!
  end

  def forget
    update_column :remember_id, nil
  end
  private

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
