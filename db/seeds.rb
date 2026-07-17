require "faker"

PurchaseRequest.destroy_all
User.destroy_all

alice = User.create!(
  name: "Alice Kumar",
  email: "alice@zapro.com",
  role: :requester,
  status: :active
)

bob = User.create!(
  name: "Bob Singh",
  email: "bob@zapro.com",
  role: :approver,
  status: :active
)

carol = User.create!(
  name: "Carol Patel",
  email: "carol@zapro.com",
  role: :admin,
  status: :active
)

10.times do
  alice.purchase_requests.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    amount: Faker::Commerce.price(range: 100..10000)
  )
end

puts "Seeded #{User.count} users and #{PurchaseRequest.count} purchase requests."