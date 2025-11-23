# spec/jobs/process_email_job_spec.rb
require 'rails_helper'

RSpec.describe ProcessEmailJob, type: :job do
  # Configura o Active Job para rodar imediatamente em ambiente de teste
  include ActiveJob::TestHelper

  # 1. SETUP DE DADOS E INFRAESTRUTURA
  let(:email_content) { File.read('spec/fixtures/emails/fornecedora_completo.eml') }
  let(:failed_email_content) { File.read('spec/fixtures/emails/fornecedora_falha.eml') }

  # Cria um arquivo de e-mail mockado no Active Storage
  let!(:uploaded_file_success) do
    create(:email_file, :with_attached_file, filename: 'fornecedora_completo.eml', content: email_content)
  end
  let!(:uploaded_file_failure) do
    create(:email_file, :with_attached_file, filename: 'fornecedora_falha.eml', content: failed_email_content)
  end

  # Mocka o Service para controlar o resultado do parsing
  before do
    # Garante que o Job chame o Service correto
    allow(EmailProcessorService).to receive(:new).and_call_original

    # Previne que o Turbo Streams tente renderizar no ambiente de teste
    allow(Turbo::StreamsChannel).to receive(:broadcast_replace_to)
  end

  describe '#perform' do
    context 'when processing is successful' do
      it 'creates a ProcessingLog with status success' do
        # Enfileira e executa imediatamente
        expect {
          perform_enqueued_jobs { ProcessEmailJob.perform_now(uploaded_file_success) }
        }.to change(ProcessingLog, :count).by(2).and change(Customer, :count).by(1)

        log = ProcessingLog.last
        expect(log.status).to eq('success')
        expect(log.message).to include('Sucesso! Customer criado.')
        expect(Customer.last.name).to eq('João da Silva')
      end
    end

    context 'when processing fails due to missing contact data (Rule of Business)' do
      before do
        # Mocka o parser para garantir que ele retorne falha de regra de negócio
        allow_any_instance_of(SupplierAParser).to receive(:processing_failed?).and_return(true)
      end

      it 'creates a ProcessingLog with status failed' do
        expect {
          perform_enqueued_jobs { ProcessEmailJob.perform_now(uploaded_file_failure) }
        }.to change(ProcessingLog, :count).by(2).and change(Customer, :count).by(0) # Cliente não deve ser criado

        log = ProcessingLog.last
        expect(log.status).to eq('failed')
        expect(log.message).to include('Falha: Dados de contato não encontrados.')
      end
    end

    context 'when a fatal error occurs during parsing' do
      before do
        # Simula um erro na chamada do parser
        allow(EmailProcessorService).to receive(:new).and_raise('Simulated Fatal Error')
      end

      it 'captures the error and logs status error' do
        expect {
          perform_enqueued_jobs { ProcessEmailJob.perform_now(uploaded_file_success) }
        }.to change(ProcessingLog, :count).by(2)

        log = ProcessingLog.last
        expect(log.status).to eq('error')
        expect(log.message).to include('Erro fatal: Simulated Fatal Error')
        expect(log.backtrace).to_not be_nil
      end
    end
  end
end
