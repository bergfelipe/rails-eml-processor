class Cliente < ApplicationRecord
    validates :email, uniqueness: true, allow_blank: true
    validates :telefone, uniqueness: true, allow_blank: true
  end
  