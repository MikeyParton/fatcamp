# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

	weigh_ins = [
		{ weight: 165, text: "this is my first weigh in", created_at: Time.now - 7.days },
		{ weight: 164, text: "lost a pound", created_at: Time.now - 6.days },
		{ weight: 159, text: "awwww yeah", created_at: Time.now - 5.days },
		{ weight: 159, text: "steady", created_at: Time.now - 4.days },
		{ weight: 159, text: "steady", created_at: Time.now - 3.days },
		{ weight: 200, text: "oh fuck!", created_at: Time.now - 2.days },
		{ weight: 180, text: "I don't feel good", created_at: Time.now - 1.day },
		{ weight: 175, text: "....", created_at: Time.now }
	]

	weigh_ins.each do |w|
		p = Post.new(w)
		p.user_id = 13
		p.save
	end