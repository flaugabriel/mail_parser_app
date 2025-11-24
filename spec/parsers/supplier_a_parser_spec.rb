require "rails_helper"

RSpec.describe Parsers::SupplierAParser do
  let(:email_body) do
    <<~BODY
      Olá equipe,

      Gostaria de solicitar informações sobre o produto de código ABC123.

      Nome do cliente: João da Silva
      E-mail: joao.silva@example.com
      Telefone: (11) 91234-5678

      Atenciosamente,
      João da Silva
    BODY
  end

  let(:raw_email) do
    <<~MAIL
      From: loja@fornecedora.com
      To: vendas@suaempresa.com
      Subject: Pedido Teste

      #{email_body}
    MAIL
  end

  let(:parser) { described_class.new(raw_email) }

  before do
    allow(parser).to receive(:extract_text_body).and_return(email_body)
  end

  describe "#parse!" do
    before { parser.parse! }

    it "extrai corretamente o nome do cliente" do
      expect(parser.instance_variable_get(:@client_name)).to eq("João da Silva")
    end

    it "extrai corretamente o email do cliente" do
      expect(parser.instance_variable_get(:@client_email)).to eq("joao.silva@example.com")
    end

    it "extrai corretamente o telefone" do
      expect(parser.instance_variable_get(:@client_phone)).to eq("(11) 91234-5678")
    end

    it "extrai corretamente o código do produto" do
      expect(parser.instance_variable_get(:@product_code)).to eq("ABC123")
    end
  end

  describe "#to_h_of_extracted_data" do
    it "retorna um hash com os valores extraídos" do
      parser.parse!

      expect(parser.to_h_of_extracted_data).to include(
        client_name: "João da Silva",
        client_email: "joao.silva@example.com",
        client_phone: "(11) 91234-5678",
        product_code: "ABC123"
      )
    end
  end

  describe "métodos privados" do
    it "extract_field retorna nil quando não encontra correspondência" do
      missing_regex = /Não existe:/i

      result = parser.send(:extract_field, email_body, missing_regex)
      expect(result).to be_nil
    end

    it "extract_field retorna o valor limpo quando encontra correspondência" do
      result = parser.send(:extract_field, "Nome do cliente:  Teste  ", /Nome do cliente:\s*(.*)/i)
      expect(result).to eq("Teste")
    end
  end
end
