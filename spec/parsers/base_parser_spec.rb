require "rails_helper"

RSpec.describe Parsers::BaseParser do
  let(:raw_email) do
    <<~MAIL
      From: teste@example.com
      To: app@example.com
      Subject: Teste BaseParser

      Corpo simples do email.
    MAIL
  end

  let(:parser) { described_class.new(raw_email) }

  describe "#initialize" do
    it "armazenar o assunto do e-mail" do
      expect(parser.subject).to eq("Teste BaseParser")
    end
  end

  describe "#parse!" do
    it "raise NotImplementedError porque deve ser implementado pela subclasse" do
      expect { parser.parse! }.to raise_error(NotImplementedError)
    end
  end

  describe "#processing_failed?" do
    context "quando client_email e client_phone estão faltando" do
      it "retorna true" do
        expect(parser.processing_failed?).to be true
      end
    end

    context "quando pelo menos um dos dados existe" do
      it "retorna false se client_email estiver presente" do
        parser.instance_variable_set(:@client_email, "teste@example.com")
        expect(parser.processing_failed?).to be false
      end

      it "retorna false se client_phone estiver presente" do
        parser.instance_variable_set(:@client_phone, "11999990000")
        expect(parser.processing_failed?).to be false
      end
    end
  end

  describe "#extract_text_body" do
    context "quando o email NÃO é multipart" do
      it "retorna o corpo corretamente como UTF-8" do
        body = parser.send(:extract_text_body)
        expect(body).to eq("Corpo simples do email.\n")
      end
    end

    context "quando o email É multipart" do
      let(:multipart_raw_email) do
        <<~MAIL
          MIME-Version: 1.0
          Content-Type: multipart/alternative; boundary="abc123"
          Subject: Email Multipart

          --abc123
          Content-Type: text/plain; charset=UTF-8

          Parte texto do email.

          --abc123
          Content-Type: text/html; charset=UTF-8

          <p>parte HTML</p>
          --abc123--
        MAIL
      end

      let(:multipart_parser) { described_class.new(multipart_raw_email) }

      it "retorna o text_part quando multipart" do
        extracted = multipart_parser.send(:extract_text_body)
        expect(extracted).to include("Parte texto do email.")
      end
    end
  end
end
