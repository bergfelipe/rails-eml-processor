class EmailRecebido < ApplicationRecord
    has_one_attached :arquivo_email
end
