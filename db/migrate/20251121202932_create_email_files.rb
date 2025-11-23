class CreateEmailFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :email_files do |t|
      t.string :filename
      t.string :status, default: 0

      t.timestamps
    end
  end
end
