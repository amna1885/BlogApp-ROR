# frozen_string_literal: true

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)

# # db/seeds.rb

# admin_user = User.create(email: 'admin123@example.com', password: 'password11')
# admin_user.add_role :admin

# moderator_user = User.create(email: 'moderator123@example.com', password: 'password')
# moderator_user.add_role :moderator

# regular_user = User.create(email: 'user123@example.com', password: 'password')
# regular_user.add_role :user

# # Create posts with the admin user as the author
# post1 = Post.create!(
#   title: 'First Post',
#   content: 'This is the content of the first post.',
#   user: admin_user
# )
# post2 = Post.create!(
#   title: 'Second Post',
#   content: 'This is the content of the second post.',
#   user: moderator_user
# )

# # Create comments with the admin user as the author
# Comment.create!(
#   content: 'Great post!',
#   post: post1,
#   user: admin_user
# )
# Comment.create!(
#   content: 'Thanks for sharing.',
#   post: post2,
#   user: regular_user
# )

# # Create likes by the admin user
# Like.create!(
#   post: post1,
#   user: admin_user
# )
# Like.create!(
#   post: post2,
#   user: moderator_user
# )
# db/seeds.rb

# # Fetch existing users or create new ones if not found
# admin_user = User.find_or_create_by!(email: 'admin1234@example.com') do |user|
#   user.password = 'password11'
#   user.add_role :admin
# end

# moderator_user = User.find_or_create_by!(email: 'moderator1234@example.com') do |user|
#   user.password = 'password'
#   user.add_role :moderator
# end

# regular_user = User.find_or_create_by!(email: 'user1234@example.com') do |user|
#   user.password = 'password'
#   user.add_role :user
# end

# # Create posts with the users as the authors
# post1 = Post.find_or_create_by!(
#   title: 'First',
#   content: 'This is the content of the first post.',
#   user: admin_user
# )
# post2 = Post.find_or_create_by!(
#   title: 'Second',
#   content: 'This is the content of the second post.',
#   user: moderator_user
# )

# # Create comments with the users as authors
# Comment.find_or_create_by!(
#   content: 'Great',
#   post: post1,
#   user: admin_user
# )
# Comment.find_or_create_by!(
#   content: 'Thanks for sharing.',
#   post: post2,
#   user: regular_user
# )

# # Create likes by the users
# Like.find_or_create_by!(
#   post: post1,
#   user: admin_user
# )
# Like.find_or_create_by!(
#   post: post2,
#   user: moderator_user
# )

# Clear existing data
# Role.destroy_all
# User.destroy_all

# Create roles
Role.create!(name: 'admin')
Role.create!(name: 'moderator')
Role.create!(name: 'user')

# Create users and assign roles
admin = User.create!(email: 'admin123@example.com', password: 'password', password_confirmation: 'password')
admin.add_role :admin

moderator = User.create!(email: 'mod123@example.com', password: 'password', password_confirmation: 'password')
moderator.add_role :moderator

user = User.create!(email: 'user123@example.com', password: 'password', password_confirmation: 'password')
user.add_role :user
