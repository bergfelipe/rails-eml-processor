class AjustarClientesELogs < ActiveRecord::Migration[7.1]
  def change
    remove_column :clientes, :codigo_produto, :string
    remove_column :clientes, :assunto, :string

    add_reference :log_processamentos, :cliente, foreign_key: true
  end
end
