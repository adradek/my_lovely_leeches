class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.references :import_source, null: false, foreign_key: true
      t.string :place
      t.string :point
      t.string :section
      t.date :collected_on
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
