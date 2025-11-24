module Processadores
    class ProcessadorEmail
      attr_reader :arquivo_email
  
      # ----------------------------------------------------
      # Tabela de parsers — facilmente extensível no futuro
      # ----------------------------------------------------
      PARSERS = {
        /fornecedorA/i => Parsers::FornecedorAParser,
        /parceiroB/i   => Parsers::ParceiroBParser
      }
  
      def initialize(arquivo_email)
        @arquivo_email = arquivo_email
      end
  
      def executar
        caminho = arquivo_email.arquivo_email.blob.service
                       .send(:path_for, arquivo_email.arquivo_email.key)
  
        parser = escolher_parser(caminho)
        dados  = parser.extrair
  
        if dados[:email].blank? && dados[:telefone].blank?
          return { erro: "Não foi possível extrair informações de contato.", dados: dados }
        end
 
        cliente_existente = buscar_cliente_existente(dados)
        if cliente_existente
          return { erro: "Cliente já existe (e-mail ou telefone duplicado).", dados: dados }
        end
  byebug
        cliente = Cliente.create!(
          nome: dados[:nome],
          email: dados[:email],
          telefone: dados[:telefone],
          produto: dados[:codigo_produto]
        )
  
        dados[:cliente_id] = cliente.id
        dados
      end
  
      private
  
      # ----------------------------------------------------
      # Seleciona automaticamente o parser baseado no FROM
      # ----------------------------------------------------
      def escolher_parser(caminho)
        remetente = Mail.read(caminho).from&.first.to_s
  
        PARSERS.each do |regex, parser_class|
          return parser_class.new(caminho) if remetente.match?(regex)
        end
  
        raise "Nenhum parser encontrado para o remetente #{remetente}"
      end
  
      # busca segura
      def buscar_cliente_existente(dados)
        if dados[:email].present? && dados[:telefone].present?
          Cliente.find_by("email = ? OR telefone = ?", dados[:email], dados[:telefone])
        elsif dados[:email].present?
          Cliente.find_by(email: dados[:email])
        elsif dados[:telefone].present?
          Cliente.find_by(telefone: dados[:telefone])
        end
      end
    end
  end
  