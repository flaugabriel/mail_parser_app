FactoryBot.define do
  factory :email_file do
    status { :processing }

    after(:build) do |email_file|
      unless email_file.file.attached?
        email_file.file.attach(
          io: StringIO.new("fake email content"),
          filename: "example.eml",
          content_type: "message/rfc822"
        )
      end
    end
  end
end
