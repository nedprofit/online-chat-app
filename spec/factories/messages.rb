FactoryBot.define do
  factory :message do
    body { "Message text" }
    chat
    user
  end
end
