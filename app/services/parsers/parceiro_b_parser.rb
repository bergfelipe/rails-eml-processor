module Parsers
  class ParceiroBParser < BaseParser

    def extrair
      {
        nome: extrair_nome,
        email: extrair_email,
        telefone: extrair_telefone,
        codigo_produto: extrair_produto,
        assunto: assunto,
        remetente: remetente,
        destinatario: destinatario
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
      corpo[/Fone:\s*(.+)/i, 1]
    end

    def extrair_produto
      produto = corpo[/^(Produto|Descrição|Código|Código do produto|Produto de interesse|Produto desejado)\s*:\s*([A-Z0-9\-_]+)/i, 2]
      return produto if produto.present?
      produto = corpo[/c[oó]digo\s+([A-Z0-9\-_]+)/i, 1]
      return produto if produto.present?
      produto = corpo[/produto\s+([A-Z0-9\-_]+)/i, 1]
      return produto if produto.present?
      corpo[/\b([A-Z]{2,}\d{2,})\b/, 1]
    end
    
  end
end
