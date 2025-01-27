FactoryBot.define do
  factory :post do
    title { "テストタイトル" }
    content { "テストコンテンツ" }
    association :user
  end
end