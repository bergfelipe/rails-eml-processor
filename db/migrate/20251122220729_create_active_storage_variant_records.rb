class CreateActiveStorageVariantRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :active_storage_variant_records do |t|
      t.belongs_to :blob, null: false
      t.string :variation_digest, null: false
    end

    add_index :active_storage_variant_records, %i[blob_id variation_digest],
              unique: true,
              name: :index_active_storage_variant_records_uniqueness
  end
end
