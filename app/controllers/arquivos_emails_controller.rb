class ArquivosEmailsController < ApplicationController
  def index
    @clientes = Cliente.order(created_at: :desc)
    @logs = LogProcessamento.order(created_at: :desc)
    @arquivos_email = ArquivoEmail.order(created_at: :desc)
  end

  def new
    @arquivo_email = ArquivoEmail.new
  end

  def create
    if params[:arquivo_email] && params[:arquivo_email][:arquivo_id]
      # reprocessar existente
      @arquivo_email = ArquivoEmail.find(params[:arquivo_email][:arquivo_id])
    else
      # novo upload
      @arquivo_email = ArquivoEmail.new(arquivo_email_params)
    end
  
    if @arquivo_email.save
      ProcessarEmailJob.perform_now(@arquivo_email.id)
  
      # Buscar o último log criado para esse arquivo
      log = LogProcessamento.where(arquivo_email_id: @arquivo_email.id)
                            .order(created_at: :desc)
                            .first
  
      if log
        redirect_to logs_processamento_path(log), notice: "Processamento finalizado."
      else
        redirect_to arquivos_email_path(@arquivo_email), notice: "Processamento finalizado (sem logs)."
      end
  
    else
      render :new
    end
  end
  
  
  

  def show
    @arquivo    = ArquivoEmail.find(params[:id])
    @log        = LogProcessamento.find_by(arquivo_email_id: params[:id])
    @cliente    = Cliente.find_by(id: @log&.cliente_id)
  end

  private

  def arquivo_email_params
    params.require(:arquivo_email).permit(:arquivo_email)
  end
end
