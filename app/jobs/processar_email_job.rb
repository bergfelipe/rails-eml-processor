class ProcessarEmailJob < ApplicationJob
  queue_as :default

  def perform(arquivo_email_id)
    arquivo_email = ArquivoEmail.find(arquivo_email_id)

    processador = Processadores::ProcessadorEmail.new(arquivo_email)
    dados = processador.executar

    # CASO DE ERRO
    if dados.is_a?(Hash) && dados[:erro].present?
      log = LogProcessamento.create!(
        arquivo_email: arquivo_email,
        status: "falha",
        mensagem: dados[:erro],
        remetente: dados[:dados][:remetente],
        produto: dados[:dados][:codigo_produto],
        destinatario: dados[:dados][:destinatario],
        assunto: dados[:dados][:assunto],
        dados_extraidos: dados[:dados],
        cliente_id: nil
      )
      arquivo_email.update!(processado: false)

      return {
        status: :falha,
        mensagem: dados[:erro],
        log: log,
        cliente: nil
      }
    end

    # SUCESSO
    log = LogProcessamento.create!(
      arquivo_email: arquivo_email,
      status: "sucesso",
      mensagem: "Processado com sucesso",
      remetente: dados[:remetente],
      produto: dados[:codigo_produto],
      destinatario: dados[:destinatario],
      assunto: dados[:assunto],
      dados_extraidos: dados,
      cliente_id: dados[:cliente_id]
    )

    arquivo_email.update!(processado: true)

    return {
      status: :sucesso,
      mensagem: "Processado com sucesso",
      log: log,
      cliente: Cliente.find(dados[:cliente_id])
    }

  rescue => e
    log = LogProcessamento.create!(
      arquivo_email: arquivo_email,
      status: "falha",
      mensagem: e.message,
      dados_extraidos: {},
      cliente_id: nil
    )

    arquivo_email.update!(processado: false)

    return {
      status: :falha,
      mensagem: e.message,
      log: log,
      cliente: nil
    }
  end
end
