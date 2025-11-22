class ArquivosEmailsController < ApplicationController
  def index
    @arquivos = ArquivoEmail.all
  end

  def new
    @arquivo_email = ArquivoEmail.new
  end

  def create
    @arquivo_email = ArquivoEmail.new(arquivo_email_params)

    if @arquivo_email.save
      redirect_to arquivos_emails_path, notice: "Arquivo enviado com sucesso!"
    else
      render :new
    end
  end

  private

  def arquivo_email_params
    params.require(:arquivo_email).permit(:arquivo_email) # o attachment
  end
end
