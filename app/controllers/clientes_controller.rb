class ClientesController < ApplicationController
  def index
    @clientes = Cliente.order(created_at: :desc)
  end

  def show
    @cliente = Cliente.find(params[:id])
    @logs_cliente = LogProcessamento.where(cliente_id: params[:id])
  end
end
