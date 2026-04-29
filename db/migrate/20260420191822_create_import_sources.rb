class CreateImportSources < ActiveRecord::Migration[8.1]
  def change
    create_table :import_sources do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.jsonb :memo

      t.timestamps
    end
  end
end
