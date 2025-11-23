class ProcessingLog < ApplicationRecord
  # extends
  extend Enumerize

  # Associações
  belongs_to :email_file

  # Enum para monitoramento
  enumerize :status, in: { success: 0, failed: 1, error: 2, processing: 3 }

  # Broadcast para atualizações em tempo real (Hotwire)
  after_update_commit { broadcast_replace_to "processing_logs", partial: "processing_logs/log", target: self }
end
