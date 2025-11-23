FactoryBot.define do
  factory :processing_log do
    email_file { nil }
    status { "MyString" }
    extracted_data { "" }
    error_message { "MyText" }
    processed_at { "2025-11-21 16:29:29" }
  end
end
