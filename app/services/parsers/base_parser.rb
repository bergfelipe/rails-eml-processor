module Parsers
  class BaseParser
    attr_reader :raw_email, :mail

    def initialize(raw_email)
      @raw_email = raw_email
      @mail = Mail.read(raw_email)
    end

    def assunto
      normalize(mail.subject.to_s)
    end

    def remetente
      normalize(mail.from&.first.to_s)
    end

    def destinatario
      normalize(mail.to&.first.to_s)
    end

    def corpo
      text = mail.body.decoded
      normalize(text)
    end

    def normalize(text)
      return "" if text.nil?

      txt = text.force_encoding("UTF-8")

      return txt if txt.valid_encoding?

      txt.encode("UTF-8", invalid: :replace, undef: :replace)
    end

    def extrair
      raise NotImplementedError, "#{self.class} deve implementar #extrair"
    end
  end
end
