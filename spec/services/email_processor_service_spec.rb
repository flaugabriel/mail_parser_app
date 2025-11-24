require "rails_helper"

RSpec.describe EmailProcessorService do
  let(:valid_email_content_supplier) do
    <<~EMAIL
      From: loja@fornecedora.com
      To: vendas@suaempresa.com
      Subject: Pedido Teste

      Corpo do email...
    EMAIL
  end

  let(:valid_email_content_partner) do
    <<~EMAIL
      From: pedido@parceiro.com
      To: vendas@suaempresa.com
      Subject: Pedido Teste

      Corpo do email...
    EMAIL
  end

  let(:unknown_sender_email_content) do
    <<~EMAIL
      From: contato@desconhecido.com
      To: vendas@suaempresa.com
      Subject: Pedido Teste

      Corpo do email...
    EMAIL
  end

  describe "#process" do
    context "quando o remetente é reconhecido" do
      it "retorna uma instância do SupplierAParser se o domínio for fornecedora.com" do
        service = described_class.new(valid_email_content_supplier)

        result = service.process

        expect(result).to be_a(Parsers::SupplierAParser)
      end

      it "retorna uma instância do PartnerBParser se o domínio for parceiro.com" do
        service = described_class.new(valid_email_content_partner)

        result = service.process

        expect(result).to be_a(Parsers::PartnerBParser)
      end

      it "chama o método parse! no parser" do
        parser_instance = instance_double(Parsers::SupplierAParser)
        allow(Parsers::SupplierAParser).to receive(:new).and_return(parser_instance)
        allow(parser_instance).to receive(:parse!)

        service = described_class.new(valid_email_content_supplier)
        service.process

        expect(parser_instance).to have_received(:parse!)
      end
    end

    context "quando o remetente NÃO é reconhecido" do
      it "lança erro informando domínio desconhecido" do
        service = described_class.new(unknown_sender_email_content)

        expect { service.process }.to raise_error(
          /Parser não encontrado para o domínio: desconhecido.com/
        )
      end
    end

    context "quando ocorre um erro interno no parser" do
      it "captura e lança erro com mensagem formatada" do
        parser_instance = instance_double(Parsers::SupplierAParser)
        allow(Parsers::SupplierAParser).to receive(:new).and_return(parser_instance)
        allow(parser_instance).to receive(:parse!).and_raise(StandardError.new("Erro interno"))

        service = described_class.new(valid_email_content_supplier)

        expect { service.process }.to raise_error(/Falha no processamento do email: Erro interno/)
      end
    end
  end
end
