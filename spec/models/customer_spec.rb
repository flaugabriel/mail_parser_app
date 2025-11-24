require "rails_helper"

RSpec.describe EmailFile, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:processing_logs).dependent(:destroy) }
  end

  describe "active storage attachment" do
    it "allows attaching a file" do
      email_file = build(:email_file)

      expect(email_file.file).to be_attached
    end
  end

  describe "enumerize status" do
    it "accepts valid statuses" do
      %i[success failed error processing].each do |valid_status|
        record = build(:email_file, status: valid_status)
        expect(record.status.to_sym).to eq(valid_status)
      end
    end

    it "does not allow invalid status value" do
      record = build(:email_file, status: :invalid_value)
      expect(record.status).to be_nil
    end
  end
end
