class ProcessEmailJob < ApplicationJob
  queue_as :default # Sidekiq

  def perform(uploaded_file)
    # O arquivo precisa ser lido para ser passado para o Mail gem e o Processor
    email_content = uploaded_file.file.download

    # Log persistente de início
    log = ProcessingLog.create!(
      email_file_id: uploaded_file.id,
      status: :processing,
      message: "Iniciando processamento do arquivo: #{uploaded_file.file.filename}"
    )

    begin
      parser = EmailProcessorService.new(email_content).process

      if parser.processing_failed?
        log.update!(status: :failed, message: "Falha: Dados de contato não encontrados. Assunto: #{parser.subject}")
      else
        Customer.create!(
          name: parser.client_name,
          email: parser.client_email,
          phone: parser.client_phone,
          product_code: parser.product_code
        )
        log.update!(status: :success, message: "Sucesso! Customer criado. Assunto: #{parser.subject}", extracted_data: parser.to_h_of_extracted_data)

        latest_customers = Customer.order(created_at: :desc).limit(50)
        latest_logs = ProcessingLog.order(created_at: :desc).limit(100)

        Turbo::StreamsChannel.broadcast_replace_to "customers",
          target: "customers",
          partial: "email_files/customers",
          locals: { customers: latest_customers }

        Turbo::StreamsChannel.broadcast_replace_to "processing_logs",
          target: "processing_logs",
          partial: "email_files/processing_logs",
          locals: { logs: latest_logs }
      end
    rescue => e
      log.update!(status: :error, message: "Erro fatal: #{e.message}", backtrace: e.backtrace.first(5).join("\n"))
    end
  end
end
