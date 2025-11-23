class ArquivosEmailsController < ApplicationController
  def index
    @clientes = Cliente.order(created_at: :desc)
    @logs = LogProcessamento.order(created_at: :desc)
  end

  def new
    @arquivo_email = ArquivoEmail.new
  end

  def create
    @arquivo_email = ArquivoEmail.new(arquivo_email_params)

    if @arquivo_email.save
      ProcessarEmailJob.perform_now(@arquivo_email.id)
      redirect_to arquivos_email_path(@arquivo_email)
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
