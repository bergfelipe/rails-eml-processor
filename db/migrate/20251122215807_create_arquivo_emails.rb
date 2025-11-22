class CreateArquivoEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :arquivo_emails do |t|
      t.string :remetente
      t.boolean :processado

      t.timestamps
    end
  end
end
