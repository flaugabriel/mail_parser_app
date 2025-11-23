class CreateProcessingLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :processing_logs do |t|
      t.references :email_file, null: false, foreign_key: true
      t.string :status
      t.jsonb :extracted_data
      t.text :message
      t.text :backtrace

      t.timestamps
    end
  end
end
