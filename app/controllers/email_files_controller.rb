class EmailFilesController < ApplicationController
  # GET /email_files or /email_files.json
  def index
    @email_files = EmailFile.order(created_at: :desc).limit(100)
    @customers = Customer.order(created_at: :desc).limit(50)
    @logs = ProcessingLog.order(created_at: :desc).limit(100)
  end

  # POST /email_files or /email_files.json
  def create
    if params[:email_file].blank? || params[:email_file][:file].blank?
      flash[:alert] = "Nenhum arquivo foi selecionado."
      return redirect_to email_files_path
    end

    email_file = EmailFile.new(email_file_params.merge(save_params))

    if email_file.save
      ProcessEmailJob.perform_later(email_file)
      flash[:notice] = "Arquivo '#{email_file.file.filename}' enviado com sucesso. O processamento iniciou em background."
    else
      flash[:alert] = "Falha ao enviar arquivo: #{email_file.errors.full_messages.to_sentence}"
    end

    redirect_to email_files_path
  end

  private

  def save_params
    { status: :processing, filename: params[:email_file][:file].original_filename }
  end

  def email_file_params
    params.require(:email_file).permit(:file).merge(status: :pending)
  end
end
