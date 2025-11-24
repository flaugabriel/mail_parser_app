require 'rails_helper'

RSpec.describe ProcessingLog, type: :model do
  let(:email_file) { create(:email_file) }

  describe "associations" do
    it { is_expected.to belong_to(:email_file) }
  end

  describe "enumerize" do
    it "has the correct status options" do
      expect(ProcessingLog.status.values).to contain_exactly(
        "success", "failed", "error", "processing"
      )
    end

    it "accepts valid status" do
      log = build(:processing_log, status: :success)
      expect(log.status).to eq("success")
    end

    it "rejects invalid status" do
      log = build(:processing_log, status: :invalid)
      expect(log.status).to be_nil
    end
  end

  describe "callbacks" do
    it "broadcasts after update" do
      log = create(:processing_log, status: :processing)

      expect {
        log.update(status: :success)
      }.to have_broadcasted_to("processing_logs")
    end
  end
end
