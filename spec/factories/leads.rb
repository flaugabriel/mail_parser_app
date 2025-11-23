FactoryBot.define do
  factory :lead do
    from_email { "MyString" }
    to_email { "MyString" }
    subject { "MyString" }
    product_code { "MyString" }
    customer_name { "MyString" }
    customer_email { "MyString" }
    customer_phone { "MyString" }
  end
end
