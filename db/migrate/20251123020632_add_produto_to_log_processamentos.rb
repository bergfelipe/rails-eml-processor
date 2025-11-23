class AddProdutoToLogProcessamentos < ActiveRecord::Migration[7.1]
  def change
    add_column :log_processamentos, :produto, :string
  end
end
