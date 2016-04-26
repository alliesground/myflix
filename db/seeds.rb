# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


tv_commedy = Category.create!(name: 'tv commedies')
tv_drama = Category.create!(name: 'tv dramas')
tv_reality = Category.create!(name: 'reality tv')

user = User.create!(email: 'user@example.com', password: ENV['login_pass'], full_name: 'example user')

admin = User.create!(email: 'admin@example.com', password: ENV['login_pass'], full_name: 'admin user', admin: true)

puts "#{Video.count} videos created"
puts "#{Category.count} categories created"
puts "#{User.count} user created"


