class CreateTaxons < ActiveRecord::Migration[8.1]
  def change
    create_table :taxons do |t|
      t.string :name, null: false
      t.string :full_name
      t.string :name_ru
      t.integer :rank, null: false, default: 10
      t.references :parent, foreign_key: { to_table: :taxons }

      t.timestamps
    end
  end
end
