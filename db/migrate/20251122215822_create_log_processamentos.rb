class CreateLogProcessamentos < ActiveRecord::Migration[7.1]
  def change
    create_table :log_processamentos do |t|
      t.references :arquivo_email, null: false, foreign_key: true
      t.string :status
      t.text :mensagem
      t.jsonb :dados_extraidos

      t.timestamps
    end
  end
end
