require "rails_helper"

RSpec.describe Parsers::PartnerBParser do
  let(:email_body) do
    <<~EMAIL
      Subject: Pedido Cliente

      Prezados,

      Segue pedido referente ao produto:

      Código: PB-XYZ-001
      Favor confirmar disponibilidade.

      Contato: (11) 99999-1234
      Email: cliente.exemplo@exemplo.com

      Obrigado.

      Atenciosamente,
      João da Silva
    EMAIL
  end

  let(:parser) { described_class.new(email_body) }

  describe "#parse!" do
    before { parser.parse! }

    it "extrai o e-mail do cliente" do
      expect(parser.instance_variable_get(:@client_email)).to eq("cliente.exemplo@exemplo.com")
    end

    it "extrai o telefone do cliente" do
      expect(parser.instance_variable_get(:@client_phone)).to eq("(11) 99999-1234")
    end

    it "extrai o código do produto" do
      expect(parser.instance_variable_get(:@product_code)).to eq("PB-XYZ-001")
    end

    it "extrai o nome do cliente" do
      expect(parser.instance_variable_get(:@client_name)).to eq("João da Silva")
    end
  end

  describe "#to_h_of_extracted_data" do
    before { parser.parse! }

    it "retorna o hash formatado corretamente" do
      expect(parser.send(:to_h_of_extracted_data)).to eq(
        {
          client_name: "João da Silva",
          client_email: "cliente.exemplo@exemplo.com",
          client_phone: "(11) 99999-1234",
          product_code: "PB-XYZ-001",
          subject: "Pedido Cliente"
        }
      )
    end
  end

  context "quando o corpo não contém dados" do
    let(:parser) { described_class.new("Mensagem sem dados") }

    before { parser.parse! }

    it { expect(parser.instance_variable_get(:@client_email)).to be_nil }
    it { expect(parser.instance_variable_get(:@client_phone)).to be_nil }
    it { expect(parser.instance_variable_get(:@product_code)).to be_nil }
    it { expect(parser.instance_variable_get(:@client_name)).to be_nil }
  end
end
