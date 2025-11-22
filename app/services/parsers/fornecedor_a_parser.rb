module Parsers
  class FornecedorAParser < BaseParser

    def extrair
      {
        nome: extrair_nome,
        email: extrair_email,
        telefone: extrair_telefone,
        codigo_produto: extrair_produto,
        assunto: assunto
      }
    end

    private

    def extrair_nome
      corpo[/Nome:\s*(.+)/i, 1]
    end

    def extrair_email
      corpo[/E-mail:\s*(.+)/i, 1]
    end

    def extrair_telefone
      corpo[/Telefone:\s*(.+)/i, 1]
    end

    def extrair_produto
      assunto[/Produto\s+([A-Z0-9]+)/i, 1] ||
      corpo[/c[oó]digo\s+([A-Z0-9]+)/i, 1]
    end

  end
end
