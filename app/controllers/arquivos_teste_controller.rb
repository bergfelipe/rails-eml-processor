class ArquivosTesteController < ApplicationController
  def index
    @arquivo = ArquivoTeste.new
  end

  def create
    @arquivo = ArquivoTeste.create(arquivo_params)
    redirect_to arquivos_teste_index_path, notice: "Enviado!"
  end

  private

  def arquivo_params
    params.require(:arquivo_teste).permit(:nome, :arquivo_email)
  end
end
