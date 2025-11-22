class ProcessarEmailJob < ApplicationJob
  queue_as :default

  def perform(arquivo_email_id)
    arquivo_email = ArquivoEmail.find(arquivo_email_id)

    processador = Processadores::ProcessadorEmail.new(arquivo_email)

    begin
      dados = processador.executar

      # Se o processador retornar nil, já teve falha e log foi salvo
      return if dados.nil?

      LogProcessamento.create!(
        arquivo_email_id: arquivo_email.id,
        status: "sucesso",
        mensagem: "Processado com sucesso",
        dados_extraidos: dados
      )

    rescue => e
      LogProcessamento.create!(
        arquivo_email_id: arquivo_email.id,
        status: "falha",
        mensagem: e.message,
        dados_extraidos: {}
      )

      arquivo_email.update!(processado: false)
    end
  end
end
