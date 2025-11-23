class AddCamposEmailToLogProcessamentos < ActiveRecord::Migration[7.1]
  def change
    add_column :log_processamentos, :remetente, :string
    add_column :log_processamentos, :destinatario, :string
    add_column :log_processamentos, :assunto, :string
  end
end
