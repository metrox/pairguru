FactoryBot.define do
  factory :comment do
    commenter Faker::Name.name
    body Faker::Lorem.sentence(3, true)
    user
    movie
  end
end
