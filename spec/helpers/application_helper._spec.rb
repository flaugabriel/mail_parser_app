require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#log_row_class" do
    it "retorna 'table-success' para status 'success'" do
      expect(helper.log_row_class("success")).to eq("table-success")
    end

    it "retorna 'table-warning' para status 'failed'" do
      expect(helper.log_row_class("failed")).to eq("table-warning")
    end

    it "retorna 'table-danger' para status 'error'" do
      expect(helper.log_row_class("error")).to eq("table-danger")
    end

    it "retorna '' (string vazia) para status desconhecido" do
      expect(helper.log_row_class("unknown")).to eq("")
    end

    it "retorna '' quando status for nil" do
      expect(helper.log_row_class(nil)).to eq("")
    end
  end
end
