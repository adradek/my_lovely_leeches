class AddUniqueCompositeIndexToTaxons < ActiveRecord::Migration[8.1]
  def change
    add_index :taxons, [:name, :rank, :parent_id], unique: true, nulls_not_distinct: true
  end
end
