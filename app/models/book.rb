class Book < ApplicationRecord
  belongs_to :category
  belongs_to :author
  belongs_to :book_series, optional: true
  has_one :book_inventory, dependent: :destroy
  has_many :borrow_books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :carts, dependent: :destroy

  scope :latest, ->{order(publication_date: :desc)}
  scope :oldest, ->{order(publication_date: :asc)}
  scope :default_order, ->{order(created_at: :asc)}
  scope :filter_by_category, lambda {|category|
    return if category.blank?

    where(category_id: category&.subcategories&.pluck(:id)
                                .to_a << category.id)
  }

  scope :filter_by_search, lambda {|search_query|
    return if search_query.blank?

    where("MATCH(title, summary) AGAINST(?)", search_query)
  }

  scope :sorted_by, lambda {|sort_param|
    case sort_param
    when "latest"
      latest
    when "oldest"
      oldest
    when "highest_rating"
      joins(:ratings).group("books.id").order("AVG(ratings.rating) DESC")
    else
      default_order
    end
  }

  validates :title, :summary, :quantity, :publication_date, presence: true
  scope :in_user_cart, ->(user){where(id: user.books_in_carts.pluck(:id))}
end
