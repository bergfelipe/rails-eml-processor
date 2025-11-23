class ArquivoEmail < ApplicationRecord
    has_one_attached :arquivo_email

    validate :arquivo_deve_ser_eml

    def arquivo_deve_ser_eml
        if arquivo_email.attached? && !arquivo_email.filename.to_s.downcase.ends_with?(".eml")
            errors.add(:arquivo_email, "deve ser um arquivo .eml")
        end
    end

end
