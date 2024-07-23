# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

# using admin column
# Create an admin user
admin_user = User.create!(
  email: 'admin11@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# Create posts with the admin user as the author
post1 = Post.create!(
  title: 'First Post',
  content: 'This is the content of the first post.',
  user: admin_user
)
post2 = Post.create!(
  title: 'Second Post',
  content: 'This is the content of the second post.',
  user: admin_user
)

# Create comments with the admin user as the author
Comment.create!(
  content: 'Great post!',
  post: post1,
  user: admin_user
)
Comment.create!(
  content: 'Thanks for sharing.',
  post: post2,
  user: admin_user
)

# Create likes by the admin user
Like.create!(
  post: post1,
  user: admin_user
)
Like.create!(
  post: post2,
  user: admin_user
)
