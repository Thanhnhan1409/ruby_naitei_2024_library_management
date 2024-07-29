require "json"
require "faker"

# Load JSON files
# books_file_path = Rails.root.join("db","books.json")
# authors_file_path = Rails.root.join("db","authors.json")
# categories_file_path = Rails.root.join("db","categories.json")
# books_series_file_path = Rails.root.join("db","book_series.json")

# books_file = File.read(books_file_path)
# authors_file = File.read(authors_file_path)
# categories_file = File.read(categories_file_path)
# books_series_file = File.read(books_series_file_path)

# books = JSON.parse(books_file)
# authors = JSON.parse(authors_file)
# categories = JSON.parse(categories_file)
# books_series = JSON.parse(books_series_file)

# # Seed categories
# categories.each do |category|
#   parent = Category.create!(name: category["name"], description: category["description"])
#   category["subcategories"].each do |subcategory|
#     Category.create!(name: subcategory["name"], description: subcategory["description"], parent_id: parent.id)
#   end
# end


# # Seed authors
# authors.each do |author|
#   Author.create!(
#     name: author["name"],
#     birth: author["birth"],
#     gender: author["gender"],
#     bio: author["bio"],
#     nationality: author["nationality"],
#     profile_url: author["profile_url"]
#   )
# end

# # Seed books

# books_list = []
# books.each do |item|
#   book = Book.create(
#     title: item["name"],
#     summary: item["description"],
#     quantity: rand(1..10),
#     publication_date: Faker::Date.between(from: "2000-01-01", to: "2024-12-31"),
#     category_id: rand(1..18),
#     author_id: rand(1..20),
#     book_series_id: nil,
#     cover_url: item["book_cover"]
#   )

#   books_list << book
# end

# books_list.each do |book|
#   BookInventory.create(
#     book_id: book.id,
#     available_quantity: rand(1..10)
#   )
# end

# # Seed book series

# books_series.each do |series|
#   book_series_details = BookSeries.create!(
#     title: series["title"],
#     description: series["description"]
#   )

#   series["books"].each do |book|
#     Book.create!(
#       title: book["title"],
#       summary: book["summary"],
#       quantity: rand(1..10),
#       publication_date: book["publication_date"],
#       category_id: series["category_id"],
#       author_id: series["author_id"],
#       book_series_id: book_series_details.id,
#       cover_url: book["image_url"]
#     )
#   end
# end

# accounts = []
# 5.times do |i|
#   accounts << Account.create!(
#     email: Faker::Internet.email,
#     password: '123123',
#     password_digest: BCrypt::Password.create('123123'), # Tạo password_digest
#     remember_id: SecureRandom.hex,
#     status: :active, # Hoặc bất kỳ trạng thái mặc định nào bạn muốn
#     is_admin: [true, false].sample
#   )
# end

# # Seed dữ liệu cho User
# accounts.each do |account|
#   User.create!(
#     citizen_id: Faker::Number.number(digits: 12),
#     account: account,
#     name: Faker::Name.name,
#     birth: Faker::Date.between(from: "1970-01-01", to: "2010-12-31"),
#     gender: [1, 0].sample,
#     phone: Faker::PhoneNumber.unique.cell_phone,
#     address: Faker::Address.full_address,
#     profile_url: Faker::Avatar.image,
#     created_at: Time.now,
#     updated_at: Time.now
#   )
# end

# users = User.all
# books = Book.all

# puts users.first

# # Nếu chưa có user hoặc book, hãy seed user và book trước
# if users.empty?
#   5.times do |i|
#     users << User.create!(
#       name: "User #{i+1}",
#       email: "user#{i+1}@example.com",
#       password: "password"
#     )
#   end
#   users = User.all
# end

# if books.empty?
#   5.times do |i|
#     books << Book.create!(
#       title: "Book Title #{i+1}",
#       author: "Author #{i+1}",
#       category: "Category #{i+1}"
#     )
#   end
#   books = Book.all
# end

# # Seed dữ liệu cho Request
# requests = []
# 5.times do |i|
#   requests << Request.create!(
#     user: users.sample,
#     status: Request.statuses.keys.sample, # Chọn ngẫu nhiên một trạng thái
#     description: "Request description #{i+1}"
#   )
# end

# # Tạo dữ liệu cho requests
# request1 = Request.create!(user_id: 5, status: 1)
# request2 = Request.create!(user_id: 6, status: 1)
# request3 = Request.create!(user_id: 7, status: 1)

# # Tạo dữ liệu cho borrow_books
# BorrowBook.create!(user_id: 5, book_id: 1, request_id: request1.id, borrow_date: 10.days.ago, return_date: nil, is_borrow: true)
# BorrowBook.create!(user_id: 6, book_id: 2, request_id: request2.id, borrow_date: 15.days.ago, return_date: nil, is_borrow: true)
# BorrowBook.create!(user_id: 7, book_id: 3, request_id: request3.id, borrow_date: 20.days.ago, return_date: nil, is_borrow: true)
# # Seed dữ liệu cho BorrowBook
# requests.each do |request|
#   2.times do
#     BorrowBook.create!(
#       user: request.user,
#       book: books.sample,
#       request: request,
#       borrow_date: Date.today,
#       return_date: Date.today + rand(1..30).days, # Ngày trả ngẫu nhiên từ 1 đến 30 ngày sau ngày mượn
#       is_borrow: true, # Đặt giá trị là true hoặc false hợp lệ
#       created_at: Time.now,
#       updated_at: Time.now
#     )
#   end
# end

# users = User.order(created_at: :desc).limit(5)
# books = Book.limit(15)

# # Tạo dữ liệu mẫu cho bảng carts
# users.each_with_index do |user, index|
#   # Chọn 3 sách khác nhau cho mỗi user
#   selected_books = books[index * 3, 3]  # Chọn 3 sách liên tiếp cho mỗi user

#   selected_books.each do |book|
#     Cart.create!(
#       user_id: user.id,
#       book_id: book.id,
#       created_at: Time.now,
#       updated_at: Time.now
#     )
#   end
# end

# Kiểm tra sự tồn tại của user
user_id = 26
user = User.find_by(id: 26)
if user.nil?
  puts "User with id #{user_id} not found. Please make sure the user exists."
else
  books = Book.limit(5)

  books.each do |book|
    Cart.create!(user_id: user_id, book_id: book.id)
  end
  puts "Seeded #{books.count} carts for user with id #{user_id}."
end

# Seed authors
authors.each do |author|
  Author.create!(
    name: author["name"],
    birth: author["birth"],
    gender: author["gender"],
    bio: author["bio"],
    nationality: author["nationality"],
    profile_url: author["profile_url"]
  )
end

# Seed books

books_list = []
books.each do |item|
  book = Book.create(
    title: item["name"],
    summary: item["description"],
    description: item["short_description"],
    quantity: rand(1..10),
    publication_date: Faker::Date.between(from: "1970-01-01", to: "2024-01-01"),
    category_id: rand(1..18),
    author_id: rand(1..20),
    book_series_id: nil,
    cover_url: item["book_cover"]
  )

  books_list << book
end

books_list.each do |book|
  BookInventory.create(
    book_id: book.id,
    available_quantity: rand(1..10)
  )
end

# Seed book series

books_series.each do |series|
  book_series_details = BookSeries.create!(
    title: series["title"],
    description: series["description"]
  )

  series["books"].each do |book|
    Book.create!(
      title: book["title"],
      summary: book["summary"],
      quantity: rand(1..10),
      publication_date: book["publication_date"],
      category_id: series["category_id"],
      author_id: series["author_id"],
      book_series_id: book_series_details.id,
      cover_url: book["image_url"]
    )
  end
end
admin_account = Account.create!(
  email: "admin@gmail.com",
  password: "admin123",
  status: 0,
  is_admin: 1
)

# Tạo tài khoản và người dùng giả
50.times do
  account = Account.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    status: 0,
    is_admin: false
  )

  User.create!(
    citizen_id: Faker::Number.number(digits: 12),
    account_id: account.id,
    name: Faker::Name.name,
    birth: Faker::Date.between(from: "1970-01-01", to: "2010-12-31"),
    gender: [1, 0].sample,
    phone: Faker::PhoneNumber.unique.cell_phone,
    address: Faker::Address.full_address,
    profile_url: "default_avatar.png",
  )
end

# Tạo dữ liệu cho requests
request1 = Request.create!(user_id: 5, status: 1)
request2 = Request.create!(user_id: 6, status: 1)
request3 = Request.create!(user_id: 7, status: 1)

# Tạo dữ liệu cho borrow_books
BorrowBook.create!(user_id: 5, book_id: 1, request_id: request1.id, borrow_date: 10.days.ago, return_date: nil, is_borrow: true)
BorrowBook.create!(user_id: 6, book_id: 2, request_id: request2.id, borrow_date: 15.days.ago, return_date: nil, is_borrow: true)
BorrowBook.create!(user_id: 7, book_id: 3, request_id: request3.id, borrow_date: 20.days.ago, return_date: nil, is_borrow: true)
