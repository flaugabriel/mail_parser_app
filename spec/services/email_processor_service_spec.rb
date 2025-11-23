# spec/processors/email_processor_service_spec.rb
require 'rails_helper'

RSpec.describe EmailProcessorService do
  # Define o mapeamento dinâmico para testar a decisão
  before do
    # Mock das classes SupplierAParser para evitar dependência real de parsing aqui
    stub_const('SupplierAParser', Class.new(BaseParser) { def parse!; @client_email = 'mock@a.com'; end })
    stub_const('PartnerBParser', Class.new(BaseParser) { def parse!; @client_email = 'mock@b.com'; end })

    # Simula o mapeamento de domínio (após a correção de string matching)
    stub_const('EmailProcessorService::SENDER_MAPPING', {
      "fornecedora.com" => SupplierAParser,
      "parceirob.com" => PartnerBParser
    })
  end

  let(:supplier_email) { Mail.new(from: 'vendas@fornecedora.com', body: 'Test').to_s }
  let(:partner_email) { Mail.new(from: 'contato@parceirob.com', body: 'Test').to_s }
  let(:unknown_email) { Mail.new(from: 'desconhecido@outrosite.com', body: 'Test').to_s }

  describe '#process' do
    context 'when remittent is recognized (Supplier A)' do
      it 'returns an instance of the correct parser class' do
        parser = EmailProcessorService.new(supplier_email).process
        expect(parser).to be_a(SupplierAParser)
        expect(parser.client_email).to eq('mock@a.com')
      end
    end

    context 'when remittent is recognized (Partner B)' do
      it 'returns an instance of the correct parser class' do
        parser = EmailProcessorService.new(partner_email).process
        expect(parser).to be_a(PartnerBParser)
        expect(parser.client_email).to eq('mock@b.com')
      end
    end

    context 'when remittent is NOT recognized' do
      it 'raises an error' do
        expect {
          EmailProcessorService.new(unknown_email).process
        }.to raise_error("Parser não encontrado para o domínio: outrosite.com")
      end
    end
  end
end
