def create_users
  50.times do |n|
    User.create!(
      name: "User #{n+1}",
      email: "user#{n+1}@example.com",
      password: "password",
      password_confirmation: "password",
      admin: [true, false].sample,
      activated: true,
      activated_at: Time.zone.now
    )
  end
end

create_users


user = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  user.each { |user| user.microposts.create!(content: content) }
end

puts "create relationships"

users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
