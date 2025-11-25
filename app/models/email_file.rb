class EmailFile < ApplicationRecord
  # extends
  extend Enumerize

  # Active Storage Attachment
  has_one_attached :file

  # Associações
  has_many :processing_logs, dependent: :destroy

  enumerize :status, in: { success: 0, failed: 1, error: 2, processing: 3 }

  # Validações
  validate :file_presence

  private

  def file_presence
    errors.add(:file, "não pode estar vazio") unless file.attached?
  end
end
