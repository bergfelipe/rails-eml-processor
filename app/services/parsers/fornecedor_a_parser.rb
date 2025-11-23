module Parsers
  class FornecedorAParser < BaseParser

    def extrair
      {
        nome: extrair_nome,
        email: extrair_email,
        telefone: extrair_telefone,
        codigo_produto: extrair_produto,
        assunto: assunto,
        remetente: mail.from&.first,
        destinatario: mail.to&.first
      }
    end

    private

    def extrair_nome
      corpo[/^(Nome completo|Nome do cliente|Nome|Cliente)\s*:\s*(.+)$/i, 2]
    end

    def extrair_email
      corpo[/^(E-mail|Email|E-mail de contato|Email de contato|Contato)\s*:\s*(.+)$/i, 2]
    end

    def extrair_telefone
      corpo[/Telefone:\s*(.+)/i, 1]
    end

    def extrair_produto
      corpo[/^(Produto|Código|Codigo|Produto desejado)\s*:\s*([A-Z0-9\-_]+)/i, 2]
    end

  end
end
