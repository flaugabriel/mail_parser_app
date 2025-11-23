# spec/processors/supplier_a_parser_spec.rb
require 'rails_helper'

RSpec.describe Parsers::SupplierAParser do
  # Carrega o arquivo .eml de exemplo para garantir que o parsing é feito sobre o conteúdo real
  let(:complete_email_content) { File.read('spec/fixtures/emails/fornecedora_completo.eml') }
  let(:missing_data_email_content) { File.read('spec/fixtures/emails/fornecedora_falha.eml') }

  # Assume-se que o arquivo de fixture 'fornecedora_completo.eml' tem:
  # Nome do cliente: João da Silva
  # E-mail: joao.silva@example.com
  # Telefone: (11) 91234-5678
  # Código do produto: ABC123

  describe '#parse!' do
    context 'when email has all required data' do
      subject(:parser) { Parsers::SupplierAParser.new(complete_email_content) }
      before { parser.parse! }

      it 'extracts the client name correctly' do
        expect(parser.client_name).to eq('João da Silva')
      end

      it 'extracts the client email correctly' do
        expect(parser.client_email).to eq('joao.silva@example.com')
      end

      it 'extracts the product code correctly' do
        expect(parser.product_code).to eq('ABC123')
      end

      it 'returns false for processing_failed?' do
        expect(parser.processing_failed?).to be false
      end
    end

    context 'when email is missing contact data' do
      subject(:parser) { Parsers::SupplierAParser.new(missing_data_email_content) }
      before { parser.parse! }

      it 'returns true for processing_failed? (Rule of Business)' do
        # Assumindo que o e-mail de falha não tem email NEM telefone
        expect(parser.client_email).to be_nil
        expect(parser.client_phone).to be_nil
        expect(parser.processing_failed?).to be true
      end
    end
  end
end
