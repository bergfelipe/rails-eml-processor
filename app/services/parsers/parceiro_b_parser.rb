module Parsers
  class ParceiroBParser < BaseParser

    def extrair
      {
        nome: corpo[/Cliente:\s*(.+)/i, 1],
        email: corpo[/Contato:\s*(.+@.+)/i, 1],
        telefone: corpo[/Fone:\s*(.+)/i, 1],
        codigo_produto: corpo[/Produto:\s*([A-Z0-9]+)/i, 1],
        assunto: assunto
      }
    end

  end
end
