class LogsProcessamentosController < ApplicationController
  def index
    @logs = LogProcessamento.order(created_at: :desc)
  end

  def show
    @log        = LogProcessamento.find(params[:id])
    @arquivo    = ArquivoEmail.find_by(id: @log.arquivo_email_id)
    @cliente    = Cliente.find_by(id: @log&.cliente_id)
  
    # Buscar cliente existente caso não haja cliente vinculado
    if @cliente.nil? && @log.dados_extraidos.present?
      email = @log.dados_extraidos["email"]
      telefone = @log.dados_extraidos["telefone"]
  
      @cliente_existente = Cliente.find_by(email: email) || Cliente.find_by(telefone: telefone)
    end
  end
  
end
