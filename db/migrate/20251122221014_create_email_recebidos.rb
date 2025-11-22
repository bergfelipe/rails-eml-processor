class CreateEmailRecebidos < ActiveRecord::Migration[7.1]
  def change
    create_table :email_recebidos do |t|
      t.string :status

      t.timestamps
    end
  end
end
