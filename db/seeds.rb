# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

# Create roles using Rolify
roles = ['Admin', 'Moderator', 'User']
roles.each do |role_name|
  Role.find_or_create_by(name: role_name)
end

# Create users and assign roles
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123'
)
admin.add_role :admin

moderator = User.create!(
  email: 'moderator@example.com',
  password: 'password123'
)
moderator.add_role :moderator

regular_user = User.create!(
  email: 'user@example.com',
  password: 'password123'
)
regular_user.add_role :user

# Create posts
post1 = Post.create!(
  title: 'First Post',
  content: 'This is the content of the first post.',
  user: admin
)
post2 = Post.create!(
  title: 'Second Post',
  content: 'This is the content of the second post.',
  user: regular_user
)

# Create comments
Comment.create!(
  content: 'Great post!',
  user: regular_user,
  post: post1
)
Comment.create!(
  content: 'Thanks for sharing.',
  user: admin,
  post: post2
)

# Create likes
Like.create!(
  user: admin,
  post: post1
)
Like.create!(
  user: regular_user,
  post: post2
)
