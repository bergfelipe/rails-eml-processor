module Processadores
    class ProcessadorEmail
      attr_reader :arquivo_email
  
      def initialize(arquivo_email)
        @arquivo_email = arquivo_email
      end
  
      def executar
        caminho = arquivo_email.arquivo_email.blob.service.send(:path_for, arquivo_email.arquivo_email.key)
      
        parser = escolher_parser(caminho)
        dados  = parser.extrair
      
        # valida contato
        if dados[:email].blank? && dados[:telefone].blank?
          registrar_falha("Não foi possível extrair informações de contato.")
          arquivo_email.update(processado: false)
          return
        end
      
        cliente = Cliente.create!(
          nome: dados[:nome],
          email: dados[:email],
          telefone: dados[:telefone],
          codigo_produto: dados[:codigo_produto],
          assunto: dados[:assunto]
        )
      
        registrar_sucesso(dados)
        arquivo_email.update(processado: true)
      
        return dados
      end
      
  
      private
  
      def escolher_parser(caminho)
        remetente = Mail.read(caminho).from&.first
  
        case remetente
        when /fornecedorA/i
          Parsers::FornecedorAParser.new(caminho)
        when /parceiroB/i
          Parsers::ParceiroBParser.new(caminho)
        else
          raise "Nenhum parser encontrado para o remetente #{remetente}"
        end
      end
  
      def registrar_sucesso(dados)
        LogProcessamento.create!(
          arquivo_email: arquivo_email,
          status: "sucesso",
          mensagem: "Processado com sucesso",
          dados_extraidos: dados
        )
      end
  
      def registrar_falha(msg)
        LogProcessamento.create!(
          arquivo_email: arquivo_email,
          status: "falha",
          mensagem: msg,
          dados_extraidos: {}
        )
      end
    end
  end
  