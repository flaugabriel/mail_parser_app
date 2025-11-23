# spec/processors/base_parser_spec.rb
require 'rails_helper'

RSpec.describe Parsers::BaseParser do
  let(:email_content) { "Subject: Test\n\nBody content" }
  subject(:parser) { Parsers::BaseParser.new(email_content) }

  describe '#initialize' do
    it 'reads the email subject correctly' do
      expect(parser.subject).to eq('Test')
    end
  end

  describe '#parse!' do
    it 'raises NotImplementedError, forcing subclasses to implement it' do
      expect { parser.parse! }.to raise_error(NotImplementedError)
    end
  end

  describe '#processing_failed?' do
    # Por padrão, todos os atributos são nil antes do parsing
    it 'returns true if both client_email and client_phone are nil' do
      # Mock the attributes being nil (default state)
      allow(parser).to receive(:client_email).and_return(nil)
      allow(parser).to receive(:client_phone).and_return(nil)
      expect(parser.processing_failed?).to be true
    end

    it 'returns false if client_email is present' do
      allow(parser).to receive(:client_email).and_return('test@example.com')
      allow(parser).to receive(:client_phone).and_return(nil)
      expect(parser.processing_failed?).to be false
    end
  end
end
