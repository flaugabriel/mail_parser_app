FactoryBot.define do
  factory :customer do
    name { "João da Silva" }
    email { "joao@example.com" }
    phone { "1199999999" }
    product_code { "ABC123" }
  end
end
