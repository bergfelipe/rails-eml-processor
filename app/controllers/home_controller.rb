class HomeController < ApplicationController
  def index
    @clientes = Cliente.order(created_at: :desc)
    @logs = LogProcessamento.order(created_at: :desc)
    @arquivos_email = ArquivoEmail.order(created_at: :desc)
  end
end
