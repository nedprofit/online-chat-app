FactoryBot.define do
  factory :user do
    email { "anonymous@example.com" }
    password { "password" }
  end
end