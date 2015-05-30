# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.destroy_all
Category.destroy_all

tv_commedy = Category.create!(name: 'tv commedies')
tv_drama = Category.create!(name: 'tv dramas')
tv_reality = Category.create!(name: 'reality tv')

6.times do
	Video.create!(title:'south park', description: 'nice video',
		small_cover_url: '/tmp/south_park.jpg', category: tv_commedy)	
end
Video.create!([
	{
		title: 'monk',
		description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
		small_cover_url: '/tmp/monk.jpg',
		large_cover_url: '/tmp/monk_large.jpg',
		category: tv_commedy
	},
	{
		title: 'monk',
		description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
		small_cover_url: '/tmp/monk.jpg',
		large_cover_url: '/tmp/monk_large.jpg',
		category: tv_drama
	},
	{
		title: 'futurama',
		description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
		small_cover_url: '/tmp/futurama.jpg',
		large_cover_url: '/tmp/monk_large.jpg',
		category: tv_reality
	},
])

puts "#{Video.count} videos created"
puts "#{Category.count} categories created"

