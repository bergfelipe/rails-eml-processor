class RemoveRemetenteFromArquivoEmails < ActiveRecord::Migration[7.1]
  def change
    remove_column :arquivo_emails, :remetente, :string
  end
end
