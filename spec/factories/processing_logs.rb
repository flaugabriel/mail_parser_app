FactoryBot.define do
  factory :processing_log do
    association :email_file
    extracted_data { {} }
    message { "Processado com sucesso" }
  end
end
