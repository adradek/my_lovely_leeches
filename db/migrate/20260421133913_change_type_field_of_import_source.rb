class ChangeTypeFieldOfImportSource < ActiveRecord::Migration[8.1]
  def change
    rename_column :import_sources, :type, :format
  end
end
