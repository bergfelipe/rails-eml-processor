module Parsers
  class BaseParser
    attr_reader :raw_email, :mail

    def initialize(raw_email)
      @raw_email = raw_email
      @mail = Mail.read(raw_email) # usando gem 'mail'
    end

    # métodos que devem ser implementados pelos parsers filhos
    def remetente
      mail.from&.first
    end

    def assunto
      mail.subject
    end

    def corpo
      mail.body.decoded
    end

    def extrair
      raise NotImplementedError, "#{self.class} precisa implementar o método #extrair"
    end
  end
end
