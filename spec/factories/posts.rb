FactoryBot.define do
  factory :post do
    title { "テストタイトル" }
    content { "テストコンテンツ" }
    created_at { Time.zone.now }
    association :user
  end
end