class AddProdutoToClientes < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :produto, :string
  end
end
