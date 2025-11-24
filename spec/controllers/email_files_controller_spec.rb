require "rails_helper"

RSpec.describe EmailFilesController, type: :controller do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe "GET #index" do
    let!(:email_files) { create_list(:email_file, 3) }
    let!(:customers) { create_list(:customer, 2) }
    let!(:logs) { create_list(:processing_log, 4) }

    before { get :index }

    it "assigna as variáveis de instância corretamente" do
      expect(assigns(:email_files)).to eq(EmailFile.order(created_at: :desc).limit(100))
      expect(assigns(:customers)).to eq(Customer.order(created_at: :desc).limit(50))
      expect(assigns(:logs)).to eq(ProcessingLog.order(created_at: :desc).limit(100))
    end

    it "retorna sucesso e renderiza o template" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.eml"), "message/rfc822") }

    context "quando o arquivo é válido" do
      it "cria um EmailFile, enfileira o job e redireciona com sucesso" do
        expect {
          post :create, params: { email_file: { file: file } }
        }.to change(EmailFile, :count).by(1)

        email_file = EmailFile.last

        # Verifica que o job foi enfileirado
        expect(ProcessEmailJob).to have_been_enqueued.with(email_file)

        # Verifica flash e redirecionamento
        expect(flash[:notice]).to include("Arquivo '#{file.original_filename}' enviado com sucesso")
        expect(response).to redirect_to(email_files_path)
      end
    end

    context "quando o arquivo falha ao salvar" do
      before do
        allow_any_instance_of(EmailFile).to receive(:save).and_return(false)
        allow_any_instance_of(EmailFile).to receive_message_chain(:errors, :full_messages).and_return([ "Erro no upload" ])
      end

      it "não cria EmailFile, mostra flash de erro e redireciona" do
        expect {
          post :create, params: { email_file: { file: file } }
        }.not_to change(EmailFile, :count)

        expect(flash[:alert]).to include("Falha ao enviar arquivo: Erro no upload")
        expect(response).to redirect_to(email_files_path)
      end
    end
  end
end
