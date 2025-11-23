# spec/factories/email_files.rb
FactoryBot.define do
  factory :email_file do
    # O Active Storage anexa o arquivo binário
    trait :with_attached_file do
      transient do
        filename { 'test_email.eml' }
        content { 'Simulated email content' }
      end

      file do
        Rack::Test::UploadedFile.new(
          StringIO.new(content),
          'message/rfc822', # Tipo MIME para .eml
          filename: filename
        )
      end
    end
  end
end
