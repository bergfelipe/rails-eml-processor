class CreateArquivoTestes < ActiveRecord::Migration[7.1]
  def change
    create_table :arquivo_testes do |t|
      t.string :nome

      t.timestamps
    end
  end
end
