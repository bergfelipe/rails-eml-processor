class LogsProcessamentosController < ApplicationController
  def index
    @logs = LogProcessamento.order(created_at: :desc)
  end

  def show
    @log        = LogProcessamento.find(params[:id])
    @arquivo    = ArquivoEmail.find_by(id: @log.arquivo_email_id)
    @cliente    = Cliente.find_by(id: @log&.cliente_id)
  
    # Pega dados extraídos
dados = @log&.dados_extraidos || {}
email = dados["email"]
telefone = dados["telefone"]

# Procura cliente somente se @cliente ainda não existe
if @cliente.nil? && (email.present? || telefone.present?)
  
  @cliente_existente =
    if email.present?
      Cliente.find_by(email: email)
    elsif telefone.present?
      Cliente.find_by(telefone: telefone)
    end

end

  end
  
end
