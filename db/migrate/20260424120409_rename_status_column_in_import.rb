class RenameStatusColumnInImport < ActiveRecord::Migration[8.1]
  def change
    rename_column :imports, :status, :state
  end
end
