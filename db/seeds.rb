puts 'Seeding database...'

user = User.create!(
  email: 'demo@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

puts "Created demo user: #{user.email}"
puts 'Password: password123'
