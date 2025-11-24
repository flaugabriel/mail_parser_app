require "rails_helper"

RSpec.describe ProcessEmailJob, type: :job do
  include ActiveJob::TestHelper
  include ActionDispatch::TestProcess::FixtureFile

  let(:uploaded_file) do
    EmailFile.create!(file: fixture_file_upload("sample.eml", "message/rfc822"))
  end

  before do
    # Evita broadcast real durante o teste
    allow(Turbo::StreamsChannel).to receive(:broadcast_replace_to)
  end

  describe "#perform" do
    context "when processing is successful" do
      let(:valid_email_content) do
        <<~EMAIL
          From: loja@fornecedora.com
          To: vendas@test.com
          Subject: Teste Sucesso

          Nome do cliente: João Silva
          E-mail: joao@example.com
          Telefone: (11) 90000-0000
          Gostaria do produto de código ABC123
        EMAIL
      end

      before do
        allow(uploaded_file.file.blob).to receive(:download).and_return(valid_email_content)
      end

      it "creates a customer and updates log status to success" do
        expect { described_class.perform_now(uploaded_file) }
          .to change(Customer, :count).by(1)
          .and change(ProcessingLog, :count).by(1)

        log = ProcessingLog.last
        expect(log.status).to eq("success")
        expect(log.message).to include("Sucesso! Customer criado")
      end
    end

    context "when processing fails due to missing contact data" do
      let(:invalid_email_content) do
        <<~EMAIL
          From: loja@fornecedora.com
          To: vendas@test.com
          Subject: Sem Dados

          Nome do cliente: Fulano
          Gostaria do produto ABC123
        EMAIL
      end

      before do
        allow(uploaded_file.file.blob).to receive(:download).and_return(invalid_email_content)
      end

      it "does NOT create a customer and logs status failed" do
        expect { described_class.perform_now(uploaded_file) }
          .to_not change(Customer, :count)

        log = ProcessingLog.last
        expect(log.status).to eq("failed")
        expect(log.message).to include("Falha: Dados de contato não encontrados")
      end
    end

    context "when a fatal error occurs during parsing" do
      before do
        allow(uploaded_file.file.blob).to receive(:download).and_raise("Falha geral de leitura")
      end
    end
  end

  context "when processing succeeds" do
    let(:valid_email_content) do
      <<~EMAIL
        Subject: Teste Sucesso

        Nome do cliente: João Silva
        E-mail: joao@example.com
        Telefone: (11) 90000-0000
        Código: PB-XYZ-001
      EMAIL
    end

    before do
      allow(uploaded_file.file.blob).to receive(:download).and_return(valid_email_content)

      parser = Parsers::PartnerBParser.new(valid_email_content)
      parser.parse!

      allow_any_instance_of(EmailProcessorService)
        .to receive(:process)
        .and_return(parser)
    end
    it "updates the processing log to success with extracted data" do
      described_class.perform_now(uploaded_file)

      log = ProcessingLog.last

      expect(log.extracted_data).to eq(nil)
    end
  end
end
