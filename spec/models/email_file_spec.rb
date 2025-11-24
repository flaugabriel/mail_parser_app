require "rails_helper"

RSpec.describe EmailFile, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:processing_logs).dependent(:destroy) }
  end

  describe "active storage attachment" do
    it "can attach a file" do
      email_file = described_class.new
      email_file.file.attach(
        io: StringIO.new("example content"),
        filename: "test_email.eml",
        content_type: "message/rfc822"
      )

      expect(email_file.file).to be_attached
    end
  end

  describe "enumerize status" do
    it "accepts valid statuses" do
      valid_statuses = %i[success failed error processing]

      valid_statuses.each do |status|
        record = build(:email_file, status:)
        expect(record.status.to_sym).to eq(status)
      end
    end

    it "rejects invalid statuses by not setting the value" do
      record = build(:email_file, status: :invalid_option)
      expect(record.status).to be_nil
    end
  end
end
