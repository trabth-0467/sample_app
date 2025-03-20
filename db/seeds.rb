user = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  user.each { |user| user.microposts.create!(content: content) }
end
